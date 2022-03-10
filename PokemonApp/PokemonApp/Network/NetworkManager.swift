//
//  NetworkManager.swift
//  PokemonApp
//
//  Created by Matteo Cultrera on 04/03/22.
//

import Foundation
import UIKit

class NetworkManager<T: Decodable> {
    
    public func getPokemonNames(from url: String, onSuccess: @escaping (T) -> (), onError: @escaping () -> ()) {
        
        let url = URL(string: url)
        
        URLSession.shared.dataTask(with: url!) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                let pokeData = try! jsonDecoder.decode(T.self, from: data)
                onSuccess(pokeData)
            } else {
                onError()
            }
            
        }.resume()
    }
    
    public func getAPIDetails(from urlString: String, onSuccess: @escaping (T) -> (), onError: @escaping () -> ()) {
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) {
            (data, urlResponse, error) in
               if let data = data {
                   let jsonDecoder = JSONDecoder()
                   let pokeData = try! jsonDecoder.decode(T.self, from: data)
                   onSuccess(pokeData)
               } else {
                   onError()
               }
        }.resume()
    }
    
    
    public func getPokemonImage(from urlString: String, onSuccess: @escaping(Data) -> (), onError: @escaping () -> ()) {
        
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) {
            (data, urlResponse, error) in
            if let data = data {
                onSuccess(data)
            } else {
                onError()
            }
        }.resume()
        
        
        
    }
    
}
