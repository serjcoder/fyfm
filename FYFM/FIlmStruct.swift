//
//  FIlmStruct.swift
//  FYFM
//
//  Created by Сергей on 10.12.2020.
//
import Foundation

struct Film:Decodable {
    var posterPath:String?
    var adult:Bool?
    var overview:String?
    var releaseDate:String?
    var genreIds:[Int]?
    var id:Int?
    var originalTitle:String?
    var originalLanguage:String?
    var title:String?
    var backdropPath:String?
    var popularity:Int?
    var voteCount:Int?
    var video:Bool?
    var voteAverage:Int?
    
    enum CodingKeys:  String, CodingKey {
        case posterPath = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.posterPath = try? container.decode(String.self, forKey: .posterPath)
        self.adult = try? container.decode(Bool.self, forKey: .adult)
        self.overview = try? container.decode(String.self, forKey: .overview)
        self.releaseDate = try? container.decode(String.self, forKey: .releaseDate)
        self.genreIds = try? container.decode([Int].self, forKey: .genreIds)
        self.id = try? container.decode(Int.self, forKey: .id)
        self.originalTitle = try? container.decode(String.self, forKey: .originalTitle)
        self.originalLanguage = try? container.decode(String.self, forKey: .originalLanguage)
        self.title = try? container.decode(String.self, forKey: .title)
        self.backdropPath = try? container.decode(String.self, forKey: .backdropPath)
        self.popularity = try? container.decode(Int.self, forKey: .popularity)
        self.voteCount = try? container.decode(Int.self, forKey: .voteCount)
        self.video = try? container.decode(Bool.self, forKey: .video)
        self.voteAverage = try? container.decode(Int.self, forKey: .voteAverage)
    }
}



struct  FilmsListResponse: Decodable {
    var page:Int?
    var totalResults:Int?
    var totalPages:Int?
    var statusMessage:String?
    var statusCode:Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
    var results: [Film]
}
