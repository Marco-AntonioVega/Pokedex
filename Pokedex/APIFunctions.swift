//
//  APIFunctions.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/5/23.
//

import Foundation

class APIFunctions {
    
    //gets max amount of currently existing Pokemon
    static func getNationalDexCap() -> Int {
        
        var count: Int = 0;
        var request = URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon-species")!)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let jsonDictionary = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                count = jsonDictionary["count"] as! Int
                dispatchGroup.leave()
            }
        })
        
        task.resume()
        dispatchGroup.wait()
        return count
    }
    
    //gets Pokmeon variants, flavor text, and genus
    static func getSpecDetails(id: Int, completion: @escaping (PokemonSpecDetails?) -> Void) {
        
        var variants: [Any] = []
        var flavorText: String = ""
        var genus: String = ""
        
        // Create the URL object
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(id)/") else {
            print("Invalid URL")
            return
        }
            
        // Create a data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check for data
            guard let data = data else {
                print("No data received")
                return
            }

            // Handle the received data (e.g., parse JSON)
            do {
                
                //takes care of async timing
                let dispatchGroup = DispatchGroup()
                
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let varietiesArray = jsonArray["varieties"] as? [[String: Any]] {
                        
                        //make API call for each existing variant
                        for entry in varietiesArray {
                            if let pokemonArray = entry["pokemon"] as? [String: Any] {
                                
                                //signals API start
                                dispatchGroup.enter()
                                
                                //gets specific info of variant
                                getSpecVariant(variantURL: pokemonArray["url"] as! String) {
                                    pokemonVariantDetails in DispatchQueue.main.async {
                                        if let pokemonVariantDetails = pokemonVariantDetails {
                                            variants.append(PokemonVariantDetails(
                                                name: pokemonVariantDetails.name!,
                                                types: pokemonVariantDetails.types!,
                                                height: pokemonVariantDetails.height!,
                                                weight: pokemonVariantDetails.weight!,
                                                abilities: pokemonVariantDetails.abilities!,
                                                sprite: pokemonVariantDetails.sprite!
                                            ))
                                            
                                            //add flavor text to only first variant to avoid overhead
                                            if(variants.count == 1) {
                                                if let flavorTextArray = jsonArray["flavor_text_entries"] as? [[String: Any]] {
                                                    flavorText = Utility.getFlavorText(entries: flavorTextArray)
                                                }
                                                
                                                if let generaArray = jsonArray["genera"] as? [[String: Any]] {
                                                    genus = Utility.getGenus(genera: generaArray)
                                                }
                                            }
                                        }
                                        
                                        //signals API completion
                                        dispatchGroup.leave()
                                    }
                                }
                            }
                        }
                    }
                    
                    //waits until all API requests finish
                    dispatchGroup.notify(queue: DispatchQueue.main) {
                        completion(PokemonSpecDetails(variants: variants, flavorText: flavorText, genus: genus))
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()
    }
    
    //gets specific info of variant
    static func getSpecVariant(variantURL: String, completion: @escaping (PokemonVariantDetails?) -> Void) {
        
        var name: String = ""
        var types: String = ""
        var height: Float = 0
        var weight: Float = 0
        var abilities: String = ""
        var sprite: String = ""
        
        // Create the URL object
        guard let url = URL(string: variantURL) else {
            print("Invalid URL")
            return
        }

        // Create a data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check for data
            guard let data = data else {
                print("No data received")
                return
            }

            // Handle the received data (e.g., parse JSON)
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    name = Utility.capitalize(text: jsonArray["name"] as! String)
                    types = Utility.getTypes(types: jsonArray["types"] as! [[String: Any]])
                    height = jsonArray["height"] as! Float / 10.0
                    weight = jsonArray["weight"] as! Float / 10.0
                    abilities = Utility.getAbilities(abilities: jsonArray["abilities"] as! [[String: Any]])
                    sprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(String(describing: jsonArray["id"])).png"

                    completion(PokemonVariantDetails(name: name, types: types, height: height, weight: weight, abilities: abilities, sprite: sprite))
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()
    }
    
    //gets dexNum(id), name, variants, cry, flavor text, and genus
    static func getAllDetails(id: Int, completion: @escaping (PokemonAllDetails?) -> Void) {
        
        var variants: [Any] = []
        var name: String = ""
        var flavorText: String = ""
        var genus: String = ""
        
        // Create the URL object
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else {
            print("Invalid URL")
            return
        }

        // Create a data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check for data
            guard let data = data else {
                print("No data received")
                return
            }

            // Handle the received data (e.g., parse JSON)
            do {
                
                //takes care of async timing
                let dispatchGroup = DispatchGroup()
                
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let speciesArray = jsonArray["species"] as? [String: Any] {
                        name = Utility.capitalize(text: speciesArray["name"] as! String)
                            
                        //signals API start
                        dispatchGroup.enter()
                        
                        //gets variant details and flavor text
                        getSpecDetails(id: id) {
                            pokemonSpecDetails in DispatchQueue.main.async {
                                if let pokemonSpecDetails = pokemonSpecDetails {
                                    variants = pokemonSpecDetails.variants!
                                    flavorText = pokemonSpecDetails.flavorText!
                                    genus = pokemonSpecDetails.genus!
                                }
                                
                                //signals API completion
                                dispatchGroup.leave()
                            }
                        }
                    }
                        
                    // Wait for all API calls to complete
                    dispatchGroup.notify(queue: DispatchQueue.main) {
                        completion(PokemonAllDetails(id: id, name: name, variants: variants, cry: "https://pokemoncries.com/cries/\(id).mp3", flavorText: flavorText, genus: genus))
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }

        // Start the data task
        task.resume()
    }
}
