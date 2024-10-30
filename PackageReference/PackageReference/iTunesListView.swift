//
//  iTunesListView.swift
//  PackageReference
//
//  Created by Mark Dubouzet on 10/30/24.
//

import Foundation
import SwiftUI
import Combine


struct iTunesItem: Codable, Identifiable {
    let id = UUID()
    let trackName: String?
    let artworkUrl100: String?
}


struct iTunesResponse: Codable {
    let results: [iTunesItem]
}

// MARK: - ViewModel

class iTunesViewModel: ObservableObject {
    @Published var items = [iTunesItem]()
    private let imageCache = NSCache<NSString, UIImage>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchMusicData()
    }
    
    func fetchMusicData() {
        let urlString = "https://itunes.apple.com/search?term=taylor+swift&media=music"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: iTunesResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$items)
    }
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage)
        } else {
            guard let url = URL(string: urlString) else { completion(nil); return }
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageCache.setObject(image, forKey: urlString as NSString)
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
}

// MARK: - SwiftUI View
struct iTunesListView: View {
    @StateObject private var viewModel = iTunesViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                iTunesRow(item: item, viewModel: viewModel)
            }
            .navigationTitle("iTunes Results")
        }
    }
}

// MARK: - Row View with Async Image Loading
struct iTunesRow: View {
    let item: iTunesItem
    @ObservedObject var viewModel: iTunesViewModel
    @State private var albumImage: UIImage? = nil
    
    var body: some View {
        HStack {
            if let image = albumImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
                    .onAppear {
                        if let url = item.artworkUrl100 {
                            viewModel.loadImage(urlString: url) { image in
                                self.albumImage = image
                            }
                        }
                    }
            }
            Text(item.trackName ?? "Unknown Track")
                .font(.headline)
                .padding(.leading, 10)
        }
        .padding(.vertical, 5)
        .onTapGesture {
            print(item.trackName ?? "no trackname")
        }
    }
}

// MARK: - Preview
struct iTunesListView_Previews: PreviewProvider {
    static var previews: some View {
        iTunesListView()
    }
}

