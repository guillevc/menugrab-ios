//
//  TestView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 14/01/2021.
//

import SwiftUI

struct TestView: View {
    
    @ObservedObject var viewModel: TestViewModel
    
    var body: some View {
        switch viewModel.restaurant {
        case .notRequested:
            VStack {
                Text("not requested")
                Button("Request restaurant", action: { viewModel.loadRestaurant(id: "1") })
            }
        case .isLoading:
            Text("Loading")
        case .loaded(let restaurant):
            VStack {
                Text(restaurant.allCapsName)
                restaurant.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .background(Color.gray)
                Text(restaurant.imageURL)
            }
        case .failed(let error):
            Text("Error: \(error.localizedDescription)")
        }
    }
}

class TestViewModel: ObservableObject {
    
    @Published var restaurant: Loadable<RestaurantDTO>
    
    let container: DIContainer
    private var anyCancellableBag = AnyCancellableBag()
    
    init(
        container: DIContainer,
        restaurant: Loadable<RestaurantDTO> = .notRequested
    ) {
        self.container = container
        _restaurant = .init(wrappedValue: restaurant)
    }
    
    func loadRestaurant(id: String) {
        container.services.restaurantsService
            .load(restaurant: loadableBinding(\.restaurant), id: id)
    }
    
}

//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
