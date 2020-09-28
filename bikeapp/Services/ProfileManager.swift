//
//  ProfileManager.swift
//  bikeapp
//
//  Created by Dmitry Borodin on 27.09.2020.
//

import Foundation

enum ProfileManagerError: Error {
    case wrongEmail
    case wrongPassword
    case emailOrPasswordIsEmpty
    case emailExists
    case incorrectCredentials
    case unknown
}

extension ProfileManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .wrongEmail:
            return "Wrong Email format"
        case .wrongPassword:
            return "Wrong password. Password should be 6 characters long"
        case .emailOrPasswordIsEmpty:
            return "Email or password was not passed"
        case .emailExists:
            return "Selected email already in use. Please select different one"
        case .incorrectCredentials:
            return "Credentials were not found"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

class ProfileManager {
    
    // MARK: - Public properties
    
    static var shared: ProfileManager = ProfileManager()
    
    var currentProfile: Profile?
    
    
    // MARK: - Private properties
    
    private var pendingProfile: TempProfile?
    
    // Key for saved profiles in User Defaults
    private var savedProfilesKey: String { "kSavedProfiles" }
    // Simulates persistence of created profiles
    private var savedProfiles: [Profile] {
        let defaults = UserDefaults.standard
        guard let profilesData = defaults.data(forKey: savedProfilesKey) else { return [] }
        let decoder = JSONDecoder()
        guard let profiles = try? decoder.decode([Profile].self, from: profilesData) else { return [] }
        return profiles
    }
    
    private init() { }
    
    
    // MARK: - Public methods
    
    /// Creates new temp profile with first and last name
    func createNew(firstName: String, lastName: String) {
        pendingProfile = TempProfile(
            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    /// Adds email to created temp profile continuing registration
    func add(email: String) throws {
        guard let tempProfile = pendingProfile else { return }
        guard email.isEmail else {
            throw ProfileManagerError.wrongEmail
        }
        guard !savedProfiles.contains(where: { $0.email == email }) else {
            throw ProfileManagerError.emailExists
        }
        
        pendingProfile =  TempProfile(firstName: tempProfile.firstName, lastName: tempProfile.lastName, email: email, password: tempProfile.password)
    }
    
    /// Adds password to created temp profile continuing registration
    func add(password: String) throws {
        guard let tempProfile = pendingProfile else { return }
        guard password.isPassword else {
            throw ProfileManagerError.wrongPassword
        }
        pendingProfile = TempProfile(firstName: tempProfile.firstName, lastName: tempProfile.lastName, email: tempProfile.email, password: password)
    }
    
    /// Saves temp profile and sets it as current user
    func save() throws {
        guard let tempProfile = pendingProfile else { return }
        let profile = try createValidatedProfile(from: tempProfile)
        
        var savedProfiles = self.savedProfiles
        savedProfiles.append(profile)
        
        guard let profilesData = try? JSONEncoder().encode(savedProfiles) else {
            throw ProfileManagerError.unknown
        }
        
        UserDefaults.standard.set(profilesData, forKey: savedProfilesKey)
        try authenticate(profile: profile)
    }
    
    /// Authenticates previously created profile
    func authenticate(email: String, password: String) throws {
        let savedProfiles = self.savedProfiles
        guard let profile = savedProfiles.first(where: { $0.email == email && $0.password == password }) else {
            throw ProfileManagerError.incorrectCredentials
        }
        setCurrentProfile(profile)
    }
    
    
    // MARK: - Private methods
    
    private func authenticate(profile: Profile) throws {
        let savedProfiles = self.savedProfiles
        guard let profile = savedProfiles.first(where: { $0 == profile }) else {
            throw ProfileManagerError.incorrectCredentials
        }
        setCurrentProfile(profile)
    }
    
    private func setCurrentProfile(_ profile: Profile) {
        currentProfile = profile
    }
    
    private func createValidatedProfile(from tempProfile: TempProfile) throws -> Profile {
        guard let email = tempProfile.email, let password = tempProfile.password else {
            throw ProfileManagerError.emailOrPasswordIsEmpty
        }
        guard email.isEmail else {
            throw ProfileManagerError.wrongEmail
        }
        guard password.isPassword else {
            throw ProfileManagerError.wrongPassword
        }
        guard !savedProfiles.contains(where: { $0.email == email }) else {
            throw ProfileManagerError.emailExists
        }
        let profile = Profile(firstName: tempProfile.firstName, lastName: tempProfile.lastName, email: email, password: password)
        return profile
    }
}
