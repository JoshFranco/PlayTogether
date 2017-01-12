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
            //****************************************** Parsing Block ***************************************
            // Generic data
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
            // Convert generic data to JSON
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //************************************************************************************************
            
            
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
                        // in case coordinate array doesn't have objects
                        continue
                }
                
                
                // Converting Lat and Long Strings to Doubles
                guard   let latD = Double(lat),
                    let lonD = Double(lon)
                    else{
                        continue
                }
                
                let coordinate = CLLocationCoordinate2D(latitude: latD, longitude: lonD)
                
                let storeLoc = StoreLocation(title: title, coordinate: coordinate)
                
                storeLocations.append(storeLoc)
            }
            
            closure(storeLocations)
            return
            
        }catch{
            // In case there is a parsing error, it just return an empty array
            closure([])
            return
        }
        
    }
}
