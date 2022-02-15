//
//  GeoManager.swift
//  GeoJSON
//
//  Created by Marek Roslik on 14.02.22.
//
import Foundation


class GeoManager {
    //Convert data from API
    func getCurrentData() async throws -> GeoData{
        //Take url
        guard let url = URL(string: "https://waadsu.com/api/russia.geo.json") else { fatalError("Missing URL")}
        //Take url request
        let urlRequest = URLRequest(url: url)
        //Get request
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        //Chect status code
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Date error")}
        //Decod data
        let decodedData =  try JSONDecoder().decode(GeoData.self, from: data)
        //Returb date
        return decodedData
    }
}

//API data struct
struct GeoData: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let geometry: Geometry
}

struct Geometry: Codable {
    let coordinates: [[[[Double]]]]
}
