import Foundation

extension String {

    var imageURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/original/\(self)")
    }

}