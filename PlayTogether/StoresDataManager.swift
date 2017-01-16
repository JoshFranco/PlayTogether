//
//  StoresDataManager.swift
//  PlayTogether
//
//  Created by mac on 1/10/17.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import CoreLocation

class StoresDataManager {
    class func getLocation(closure: (_ locations: [StoreLocation]) -> Void) {
        
        guard let path = Bundle.main.path(forResource: "Locations", ofType: "json") else {
            closure([])
            return
        }
        
        do{
            // Parsing block
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            // Preparing the JSON retrieved data
            guard let locations = jsonData as? [[String: AnyObject]] else{
                closure([])
                return
            }
            
            var storeLocations: [StoreLocation] = []
            
            for loc in locations {
                guard   let coord       =   loc["coordinates"] as? [String],
                    let title        =   loc["title"] as? String
                    else {
                        continue
                }
                
                guard let lat = coord.first,
                    let lon = coord.last
                    else{
                        continue
                }
                
                guard   let latD = Double(lat),
                    let lonD = Double(lon)
                    else{
                        continue
                }
                
                let coordinate = CLLocationCoordinate2D(latitude: latD, longitude: lonD)
                let storeLoc = StoreLocation(title: title, coordinate: coordinate)
                
                // Adding JSON retrieved data to storeLocations array
                storeLocations.append(storeLoc)
            }
            
            closure(storeLocations)
            return
            
        }catch{
            closure([])
            return
        }
        
    }
}
