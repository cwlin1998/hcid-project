//
//  GooglePlaceImage.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/15.
//

import SwiftUI

struct GooglePlaceImage: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(url: String) {
            let urlStr = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(url)&key=\(GooglePlaceAPI.key)"
            
            guard let parsedURL = URL(string: urlStr) else {
                fatalError("Invalid URL: \(url)")
            }

            URLSession.shared.dataTask(with: parsedURL) { data, response, error in
                
                if let data = data, data.count > 0 {
                    self.data = data
                    self.state = .success
                } else {
                    self.state = .failure
                }

                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            
            }.resume()
        }
    }

    @StateObject private var loader: Loader
    var loading: Image
    var failure: Image
    var width: Int
    var height: Int
    var cornerRadius: Int

    var body: some View {
        selectImage()
            .resizable()
            .cornerRadius(CGFloat(self.cornerRadius))
            .frame(width: CGFloat(self.width), height: CGFloat(self.height))
    }

    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "photo"), width: Int, height: Int, cornerRadius: Int) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
//        print("\(url)\n")
    }

    private func selectImage() -> Image {
        switch loader.state {
        case .loading:
            return loading
        case .failure:
            return failure
        default:
            if let image = UIImage(data: loader.data) {
                return Image(uiImage: image)
            } else {
                return failure
            }
        }
    }
}

struct GooglePlaceImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "unknown_destination", width: 60, height: 60, cornerRadius: 10)
    }
}
