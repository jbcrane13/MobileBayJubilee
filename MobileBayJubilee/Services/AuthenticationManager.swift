//
//  AuthenticationManager.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Manages Firebase Authentication with Apple Sign In and Email/Password
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit

// MARK: - Authentication Manager

@MainActor
class AuthenticationManager: ObservableObject {
    // MARK: - Published Properties

    @Published var user: FirebaseAuth.User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = false

    // MARK: - Private Properties

    private var currentNonce: String?

    // MARK: - Singleton

    static let shared = AuthenticationManager()

    private init() {
        self.user = Auth.auth().currentUser
        self.isAuthenticated = user != nil

        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
                self?.isAuthenticated = user != nil
            }
        }
    }

    // MARK: - Sign In with Apple

    /// Initiate Sign in with Apple flow
    func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = AppleSignInDelegate.shared
        authorizationController.presentationContextProvider = AppleSignInDelegate.shared
        authorizationController.performRequests()
    }

    /// Complete Apple Sign In with credential
    func handleAppleSignInCompletion(_ authorization: ASAuthorization) async throws {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw AuthenticationError.invalidCredential
        }

        isLoading = true
        errorMessage = nil

        do {
            // Create Firebase credential
            let credential = OAuthProvider.appleCredential(
                withIDToken: idTokenString,
                rawNonce: nonce,
                fullName: appleIDCredential.fullName
            )

            // Sign in to Firebase
            let authResult = try await Auth.auth().signIn(with: credential)

            // Create user profile if new user
            if let fullName = appleIDCredential.fullName {
                let displayName = [fullName.givenName, fullName.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")

                if !displayName.isEmpty {
                    let changeRequest = authResult.user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    try await changeRequest.commitChanges()
                }
            }

            // Create Firestore user document if new user
            if authResult.additionalUserInfo?.isNewUser == true {
                try await createFirestoreUserDocument(for: authResult.user)
            }

            self.user = authResult.user
            self.isAuthenticated = true
            self.isLoading = false

        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            throw error
        }
    }

    // MARK: - Email/Password Authentication

    /// Sign in with email and password
    func signIn(email: String, password: String) async throws {
        isLoading = true
        errorMessage = nil

        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = authResult.user
            self.isAuthenticated = true
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            throw error
        }
    }

    /// Create new account with email and password
    func signUp(email: String, password: String, displayName: String) async throws {
        isLoading = true
        errorMessage = nil

        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)

            // Set display name
            let changeRequest = authResult.user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()

            // Create Firestore user document
            try await createFirestoreUserDocument(for: authResult.user)

            self.user = authResult.user
            self.isAuthenticated = true
            self.isLoading = false

        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            throw error
        }
    }

    /// Send password reset email
    func resetPassword(email: String) async throws {
        isLoading = true
        errorMessage = nil

        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            throw error
        }
    }

    // MARK: - Sign Out

    /// Sign out current user
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.isAuthenticated = false
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
            throw error
        }
    }

    // MARK: - Private Helper Methods

    /// Create Firestore user document for new users
    private func createFirestoreUserDocument(for user: FirebaseAuth.User) async throws {
        let userData: [String: Any] = [
            "displayName": user.displayName ?? "Jubilee Watcher",
            "email": user.email ?? "",
            "profilePhotoURL": user.photoURL?.absoluteString ?? "",
            "reputation": 50,
            "isVerifiedWatcher": false,
            "favoriteLocations": [],
            "notificationsEnabled": true,
            "notificationThreshold": 70,
            "createdAt": Timestamp(date: Date()),
            "lastLoginAt": Timestamp(date: Date())
        ]

        try await Firestore.firestore()
            .collection("users")
            .document(user.uid)
            .setData(userData)
    }

    /// Generate random nonce for Apple Sign In
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    /// Hash nonce with SHA256
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

// MARK: - Apple Sign In Delegate

class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    static let shared = AppleSignInDelegate()

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        Task {
            do {
                try await AuthenticationManager.shared.handleAppleSignInCompletion(authorization)
            } catch {
                print("❌ Apple Sign In failed: \(error.localizedDescription)")
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple Sign In error: \(error.localizedDescription)")
        Task { @MainActor in
            AuthenticationManager.shared.errorMessage = error.localizedDescription
            AuthenticationManager.shared.isLoading = false
        }
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
}

// MARK: - Authentication Error

enum AuthenticationError: LocalizedError {
    case invalidCredential
    case userNotFound
    case networkError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Invalid credentials provided"
        case .userNotFound:
            return "User not found"
        case .networkError:
            return "Network connection failed"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
