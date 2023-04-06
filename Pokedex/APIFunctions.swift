//
//  APIFunctions.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/5/23.
//

import Foundation

class APIFunctions {
    static func getNationalDexCap() {
        //        let url = `https://pokeapi.co/api/v2/pokemon-species`;
        //          let response = await fetch(url);
        //          let info = await response.json();
        //          nationalDexCap = info.count;
        
        var request = URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon-species")!)
        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //do {
                if let jsonDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                    print(jsonDictionary["count"] as? Int)
                    if let itemsArray = jsonDictionary["results"] as? [[String: AnyObject]],
                       let firstItem = itemsArray.first,
                       let firstItemDescription = firstItem["name"] as? String {
                        print("Description of the first item: \(firstItemDescription)")
                    }
                }
        })
        task.resume()
    }
}
