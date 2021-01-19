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
            Color.lightestGray
                .onAppear {
                    viewModel.loadImage()
                }
        case .isLoading:
            Color.lightestGray
        case .loaded(let image):
            Image(uiImage: image)
                .resizable()
        case .failed:
            Color.lightestGray
        }
    }
}

extension LoadableImageView {
    class ViewModel: ObservableObject {
        let imageURL: URL?
        @Published var image: Loadable<UIImage>
        
        let container: DIContainer
        private var anyCancellableBag = AnyCancellableBag()
        
        init(
            container: DIContainer,
            imageURLString: String,
            image: Loadable<UIImage> = .notRequested
        ) {
            self.container = container
            self.imageURL = URL(string: imageURLString)
            _image = .init(initialValue: image)
        }
        
        func loadImage() {
            container.services.imagesService.load(image: loadableBinding(\.image), url: imageURL)
        }
    }
}

struct LoadableImageView_Previews: PreviewProvider {
    static let previewImageURLString = "https://i.imgur.com/QypqfcI.jpeg"
    
    static var previews: some View {
        LoadableImageView(viewModel: LoadableImageView.ViewModel(container: .preview, imageURLString: previewImageURLString))
    }
}
