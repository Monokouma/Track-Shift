//
//  MoreAuthOptionsView.swift
//  iosApp
//
//  Created by Monokouma on 31/10/2025.
//

import SwiftUI

struct MoreAuthOptionsView: View {
    @Environment(\.dismiss) var dismiss
    let size: CGFloat = 120
    let onCredentialsSend: (String, String) -> Void
    
    var body: some View {
        VStack {
           
            
            
            Text("Connexion")
                .foregroundStyle(.textColor1)
                .font(.custom("Montserrat-Bold", size: 28))
                .multilineTextAlignment(.center)
                .padding()
            
            EmailLoginView { email, pass in
                onCredentialsSend(email, pass)
            }
            
            HStack {
                Divider()
                    .frame(maxWidth: .infinity, maxHeight: 0.8)
                    .background(.textColor2)
                    .padding(.horizontal)
                
                Text("Ou")
                    .foregroundStyle(.textColor1)
                    .font(.custom("Montserrat", size: 12))
                    .multilineTextAlignment(.center)
                
                Divider()
                    .frame(maxWidth: .infinity, maxHeight: 0.8)
                    .background(.textColor2)
                    .padding(.horizontal)
                
            }.frame(maxWidth: .infinity).padding()
            
            
            AuthButton(provider: .google) {
                //authWith(authProvider: .google)
            }
            
            AuthButton(provider: .apple) {
                //authWith(authProvider: .apple)
            }
            
            AuthButton(provider: .meta) {
                //authWith(authProvider: .meta)
            }.padding(.bottom, 8)
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundColor1)
            .dismissKeyboardOnTap()
        
        
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
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                    
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.system(size: 14))
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Entrer votre email")
                    .foregroundStyle(.textColor1)
                    .font(.custom("Montserrat-Medium", size: 16))
                    .padding(.leading, 4)
                    
                
                TextField("", text: $email)
                    .focused($focusedField, equals: .email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                        hideKeyboard()
                    }
                    .tint(.black)
                    .padding()
                    .background(.white)
                    .foregroundStyle(.backgroundColor1)
                    .cornerRadius(12)
            }
            .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Entrer votre mot de passe")
                    .foregroundStyle(.textColor1)
                    .font(.custom("Montserrat-Medium", size: 16))
                
                HStack {
                    Group {
                        if showPassword {
                            TextField("", text: $password)
                        } else {
                            SecureField("", text: $password)
                        }
                    }
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        hideKeyboard()
                    }
                    
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.backgroundColor1)
                            .frame(width: 24, height: 24)
                    }
                }
                .tint(.black)
                .padding()
                .background(.white)
                .foregroundStyle(.backgroundColor1)
                .cornerRadius(12)
            }
            
            HStack {
                Spacer()
                Button("Mot de passe oublié ?") {
                    hideKeyboard()
                }
                .foregroundStyle(.primaryPurple.opacity(0.8))
                .font(.system(size: 14, weight: .medium))
                .padding(.top).padding(.trailing, 4)
            }.padding(.top, 12)
            
            Button {
                
                login()
                hideKeyboard()
            } label: {
                Text("Connexion")
            }.buttonStyle(RoundButtonStyle()).padding(.top, 32)
                
        }.animation(.spring(response: 0.4), value: showError)
        .padding(.horizontal, 24)
    }
    
    private func login() {
        showError = false
        
        if email.isEmpty {
            errorMessage = "L'email est requis"
            showError = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showError = false
            })
            return
        }
        
        if password.isEmpty {
            errorMessage = "Le mot de passe est requis"
            showError = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.showError = false
            })
            return
        }
        
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
