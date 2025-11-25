//
//  MoreAuthOptionsView.swift
//  iosApp
//
//  Created by Monokouma on 31/10/2025.
//

import SwiftUI

struct MoreAuthOptionsView: View {
    @Environment(\.dismiss) var dismiss
    let size: CGFloat = 100
    let onCredentialsSend: (String, String) -> Void
    
    
    @State private var titleOpacity: Double = 0
    @State private var titleOffset: CGFloat = -20
    @State private var formOpacity: Double = 0
    @State private var formOffset: CGFloat = 30
    @State private var dividerOpacity: Double = 0
    @State private var buttonsOpacity: Double = 0
    @State private var buttonsOffset: CGFloat = 40
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [
                    .backgroundColor1,
                    .backgroundColor1.opacity(0.95),
                    .backgroundColor1
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    HStack {
                        Spacer()
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.textColor2)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(.textColor2.opacity(0.1))
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .opacity(titleOpacity)
                    
                    
                    Text("Connexion")
                        .foregroundStyle(.textColor1)
                        .font(.custom("Montserrat-Bold", size: 32))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 32)
                        .offset(y: titleOffset)
                        .opacity(titleOpacity)
                    
                    
                    EmailLoginView { email, pass in
                        onCredentialsSend(email, pass)
                    }
                    .offset(y: formOffset)
                    .opacity(formOpacity)
                    
                    
                    HStack(spacing: 16) {
                        Rectangle()
                            .fill(.textColor2.opacity(0.3))
                            .frame(height: 1)
                        
                        Text("Ou")
                            .foregroundStyle(.textColor2)
                            .font(.custom("Montserrat-Medium", size: 14))
                        
                        Rectangle()
                            .fill(.textColor2.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 32)
                    .opacity(dividerOpacity)
                    
                    
                    VStack(spacing: 12) {
                        AuthButton(provider: .google) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                        
                        AuthButton(provider: .apple) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                        
                        AuthButton(provider: .meta) {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                    .offset(y: buttonsOffset)
                    .opacity(buttonsOpacity)
                }
            }
            .dismissKeyboardOnTap()
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
            titleOffset = 0
            titleOpacity = 1.0
        }
        
        
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.1)) {
            formOffset = 0
            formOpacity = 1.0
        }
        
        
        withAnimation(.easeOut(duration: 0.5).delay(0.25)) {
            dividerOpacity = 1.0
        }
        
        
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.35)) {
            buttonsOffset = 0
            buttonsOpacity = 1.0
        }
    }
}

struct EmailLoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @FocusState private var focusedField: Field?
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    let onCredentialsSend: (String, String) -> Void
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            
            if showError {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 16))
                    
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.custom("Montserrat-Medium", size: 14))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                )
                .transition(.scale.combined(with: .opacity))
                .padding(.bottom, 20)
            }
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Adresse email")
                    .foregroundStyle(.textColor1)
                    .font(.custom("Montserrat-SemiBold", size: 15))
                    .padding(.leading, 4)
                
                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(.textColor2.opacity(0.6))
                        .font(.system(size: 16))
                    
                    TextField("nom@exemple.com", text: $email)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                        .foregroundStyle(.textColor1)
                        .font(.custom("Montserrat-Medium", size: 15))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(focusedField == .email ? .primaryPurple : .textColor2.opacity(0.2), lineWidth: 1.5)
                        )
                )
            }
            .padding(.bottom, 20)
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Mot de passe")
                    .foregroundStyle(.textColor1)
                    .font(.custom("Montserrat-SemiBold", size: 15))
                    .padding(.leading, 4)
                
                HStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.textColor2.opacity(0.6))
                        .font(.system(size: 16))
                    
                    Group {
                        if showPassword {
                            TextField("••••••••", text: $password)
                        } else {
                            SecureField("••••••••", text: $password)
                        }
                    }
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        login()
                        hideKeyboard()
                    }
                    .foregroundStyle(.textColor1)
                    .font(.custom("Montserrat-Medium", size: 15))
                    
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundStyle(.textColor2.opacity(0.6))
                            .font(.system(size: 16))
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(focusedField == .password ? .primaryPurple : .textColor2.opacity(0.2), lineWidth: 1.5)
                        )
                )
            }
            
            
            HStack {
                Spacer()
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    hideKeyboard()
                } label: {
                    Text("Mot de passe oublié ?")
                        .foregroundStyle(.primaryPurple)
                        .font(.custom("Montserrat-SemiBold", size: 14))
                }
                .padding(.top, 12)
            }
            
            
            Button {
                login()
                hideKeyboard()
            } label: {
                HStack(spacing: 8) {
                    Text("Se connecter")
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .buttonStyle(EnhancedRoundButtonStyle())
            .padding(.top, 28)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showError)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: focusedField)
        .padding(.horizontal, 32)
    }
    
    private func login() {
        showError = false
        
        if email.isEmpty {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                errorMessage = "L'adresse email est requise"
                showError = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showError = false
                }
            }
            return
        }
        
        if password.isEmpty {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                errorMessage = "Le mot de passe est requis"
                showError = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showError = false
                }
            }
            return
        }
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        onCredentialsSend(email, password)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(white: 0.15))
            .foregroundStyle(.white)
            .cornerRadius(12)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil,
                from: nil,
                for: nil
            )
        }
    }
}

#Preview {
    MoreAuthOptionsView { email, pass in
        
    }
}
