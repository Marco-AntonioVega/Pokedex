//
//  Utility.swift
//  Pokedex
//
//  Created by Marco-Antonio Vega on 4/7/23.
//

import Foundation

class Utility {
    
    //formats names
    static func capitalize(text: String) -> String {
        if(text.firstIndex(of: "-") == nil) {
            return text.capitalized
        }
        
        var res: String = ""
        let arr = text.components(separatedBy: "-")
        
        for word in arr {
            res += (res == "" ? "" : " ") + word.capitalized
        }
        return res
    }

    //gets types of input pokemon
    static func getTypes(types: [[String:Any]]) -> String {
        var res: String = ""
        for type in types {
            if let typeArray = type["type"] as? [String: Any] {
                res += (res == "" ? "" : "/") + capitalize(text: typeArray["name"] as! String)
            }
        }
        //var name: String = types[0].type.name;
//      let res = `<img src="img/types/${name}.png" class="typeIcon">` + capitalize(name);
//      if(types.length > 1) {
//        name = types[1].type.name;
//        res += " / " + `<img src="img/types/${name}.png" class="typeIcon">` + capitalize(name);
//      }
      return res;
    }

    //gets abilities of input pokemon
    static func getAbilities(abilities: [[String: Any]]) -> String{
        var res: String = ""
        for ability in abilities {
            if let abilityArray = ability["ability"] as? [String: Any] {
                res += (res == "" ? "" : ", ") + capitalize(text: abilityArray["name"] as! String)
            }
        }
      return res;
    }

    //get genus of input pokemon
    static func getGenus(genera: [[String: Any]]) -> String {
        for entry in genera {
            if let entryArray = entry["language"] as? [String: Any] {
                if(entryArray["name"] as! String == "en") {
                    return entry["genus"] as! String
                }
            }
        }
        return ""
    }

    //get height of input pokemon
    static func getHeight(height: Float) -> String {
        return String(format: "%.1f m", height)
    }

    //gets weight of input pokemon
    static func getWeight(weight: Float) -> String {
        return String(format: "%.1f kg", weight)
    }

    //gets first English flavor text
    static func getFlavorText(entries: [[String: Any]]) -> String {
        for entry in entries {
            if let entryLanguageArray = entry["language"] as? [String: Any] {
                if(entryLanguageArray["name"] as! String == "en") {
                    return entry["flavor_text"] as! String
                }
            }
        }
        return ""
    }
    
    //get rid of special characters in flavor text
    static func filterFlavorText(text: String) -> String {
//        let regex = try! NSRegularExpression(pattern: "\\bthe\\b", options: .caseInsensitive)
        let res = text.replacingOccurrences(of: "[the]", with: "", options: .regularExpression)
//        var res = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(0..<text.utf16.count), withTemplate: "")
      //text = text.replace(/[^a-zA-Z0-9'’".,:;é—-]/g, " ");
      //let arr = text.split(" ");
//      arr.forEach((x) => {
//        if(x.length > 1 && x[0] == x[0].toUpperCase() && x[1] == x[1].toUpperCase()) {
//          res = res.concat(res.length == 0 ? "":" ", x[0].concat(x.slice(1).toLowerCase()));
//        }
//        else {
//          res = res.concat(res.length == 0 ? "":" ", x);
//        }
//      });
      return res;
    }

    //pads dex num with 0s
    static func pad(id: Int) -> String {
        if(id/10 == 0) {
            return "000\(id)";
        } else if(id/10 < 10) {
            return "00\(id)";
        } else if(id/10 < 100) {
            return "0\(id)";
        }
      return "\(id)";
    }
}
