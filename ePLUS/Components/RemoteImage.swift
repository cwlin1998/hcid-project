//
//  RemoteImage.swift
//  ePLUS
//
//  Created by yangchienying on 2020/12/15.
//

import SwiftUI

struct RemoteImage: View {
    private enum LoadState {
        case loading, success, failure
    }

    private class Loader: ObservableObject {
        var data = Data()
        var state = LoadState.loading

        init(url: String) {
            
            guard let parsedURL = URL(string: url) else {
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
    var width: Float
    var height: Float
    var cornerRadius: Int

    var body: some View {
        selectImage()
            .resizable()
            .cornerRadius(CGFloat(self.cornerRadius))
            .frame(width: CGFloat(self.width), height: CGFloat(self.height))
    }

    init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "photo"), width: Float, height: Float, cornerRadius: Int) {
        _loader = StateObject(wrappedValue: Loader(url: url))
        self.loading = loading
        self.failure = failure
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
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

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "zuccottiPark", width: 60, height: 60, cornerRadius: 10)
    }
}
