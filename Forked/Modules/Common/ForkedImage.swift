//
//  ForkedImage.swift
//  Forked
//
//  Created by Thomas Rademaker on 1/19/25.
//

import SwiftUI
import Storage

enum ImageType {
    case url(url: String?, sfSymbol: String)
    case asset(Image)
    case diskURL(path: URL, sfSymbol: String)
    case data(Data?, sfSymbol: String)
}

struct ForkedImage: View {
    let image: ImageType
    
    var body: some View {
        switch image {
        case .url(let imageURL, let symbol):
            URLImage(imageURL: imageURL, symbol: symbol)
        case .asset(let image):
            image
                .resizable()
        case .diskURL(let path, let symbol):
            if let imageData = try? Data(contentsOf: path),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                CommonSystemImage(systemName: symbol)
            }
        case .data(let data, let symbol):
            if let data, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                CommonSystemImage(systemName: symbol)
            }
        }
    }
}

fileprivate struct URLImage: View {
    @Environment(\.imageFetcher) private var imageFetcher
    let imageURL: String?
    let symbol: String
    @State private var diskURL: URL?
    
    var body: some View {
        Group {
            if let diskURL {
                ForkedImage(image: .diskURL(path: diskURL, sfSymbol: symbol))
            } else {
                AsyncImage(url: URL(string: imageURL ?? ""), content: {
                    $0.resizable()
                        .scaledToFit()
                }, placeholder: {
                    CommonSystemImage(systemName: symbol)
                })
            }
        }
        .onAppear(perform: checkIfFileExists)
        .task { await fetchImage() }
    }
    
    private func checkIfFileExists() {
        guard let imageURL else { return }
        let normalizedURL = ImageFetcher.normalizeURL(imageURL)
        if Storage.fileExists(normalizedURL, in: .caches) {
            diskURL = Storage.url(for: normalizedURL, in: .caches)
        }
    }
    
    private func fetchImage() async {
        guard let imageURL else { return }
        await imageFetcher.fetchImage(from: imageURL)
    }
}

fileprivate struct CommonSystemImage: View {
    var systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    ForkedImage(image: .url(url: "", sfSymbol: "person"))
        .environment(\.imageFetcher, ImageFetcher())
}
