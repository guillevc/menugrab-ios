//
//  LoadableImageView.swift
//  Menugrab
//
//  Created by Guillermo Alfonso Varela Chouciño on 15/01/2021.
//

import SwiftUI

struct LoadableImageView: View {
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        switch viewModel.image {
        case .notRequested:
            VStack {
                Text("not requested")
                Button("Request image", action: { viewModel.loadImage() })
            }
        case .isLoading:
            Text("Loading")
        case .loaded(let image):
            VStack {
                Text(viewModel.imageURL.absoluteString)
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .background(Color.gray)
                
            }
        case .failed(let error):
            Text("Error: \(error.localizedDescription)")
        }
    }
}

extension LoadableImageView {
    class ViewModel: ObservableObject {
        let imageURL: URL
        @Published var image: Loadable<UIImage>
        
        let container: DIContainer
        private var anyCancellableBag = AnyCancellableBag()
        
        init(
            container: DIContainer,
            imageURL: URL,
            image: Loadable<UIImage> = .notRequested
        ) {
            self.container = container
            self.imageURL = imageURL
            _image = .init(initialValue: image)
        }
        
        func loadImage() {
            container.services.imagesService.load(image: loadableBinding(\.image), url: imageURL)
        }
    }
}

struct LoadableImageView_Previews: PreviewProvider {
    static let previewImageURL = URL(string: "https://i.imgur.com/QypqfcI.jpeg")!
    
    static var previews: some View {
        LoadableImageView(viewModel: LoadableImageView.ViewModel(container: AppEnvironment.initialize().container, imageURL: previewImageURL))
    }
}
