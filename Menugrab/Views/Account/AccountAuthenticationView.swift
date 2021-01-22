//
//  AccountAuthenticationView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 21/01/2021.
//

import SwiftUI
import FirebaseAuth

struct AccountAuthenticationView: View {
    @ObservedObject var viewModel: AccountAuthenticationViewModel
    
    var body: some View {
        VStack {
            Button("TEST REQUEST RESTAURANT", action: { viewModel.testRestaurantRequest() })
            switch viewModel.restaurants {
            case .notRequested:
                Text("Not requested")
            case .isLoading:
                Text("loading...")
            case let.loaded(restaurants):
                Text(restaurants.first!.name)
            case let .failed(error):
                Text(error.localizedDescription)
            }
            switch viewModel.user {
            case .notRequested:
                VStack {
                    Text("Not requested.")
                    TextField("Email", text: $viewModel.email)
                    SecureField("Password", text: $viewModel.password)
                    HStack {
                        Button("Sign up", action: { viewModel.create() })
                        Button("Log in", action: { viewModel.signIn() })
                        Button("Log in", action: { viewModel.signOut() })
                    }
                }
                .padding()
            case let .loaded(user):
                VStack {
                    Text(user.uid)
                    Button("Sign up/Log in another account", action: { viewModel.user = Loadable.notRequested })
                }
                .padding()
            case .isLoading:
                Text("loading...")
                    .padding()
            case let .failed(error):
                VStack {
                    Text(error.localizedDescription)
                    Button("Retry", action: { viewModel.user = Loadable.notRequested })
                }
                .padding()
            }
        }
    }
}

struct AccountAuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AccountAuthenticationView(viewModel: AccountAuthenticationViewModel(container: .preview))
    }
}

final class AccountAuthenticationViewModel: NSObject, ObservableObject {
    @Published var user: Loadable<FirebaseAuth.User>
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var restaurants: Loadable<[Restaurant]> = .notRequested
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        user: Loadable<FirebaseAuth.User> = .notRequested
    ) {
        self.container = container
        _user = .init(wrappedValue: user)
    }
    
    func create() {
        container.services.usersService
            .create(user: loadableBinding(\.user), email: email, password: password)
    }
    
    func signIn() {
        container.services.usersService
            .signIn(user: loadableBinding(\.user), email: email, password: password)
    }
    
    func signOut() {
        container.services.usersService.signOut()
    }
    
    func testRestaurantRequest() {
        container.services.restaurantsService.loadNearby(restaurants: loadableBinding(\.restaurants), coordinates: nil)
    }
}
