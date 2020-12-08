//
//  API.swift
//  ePLUS
//
//  Created by 林承緯 on 2020/12/7.
//

import SwiftUI

struct API {
    let hostURL = "http://localhost:8000"
    
    func getPlan(planId: String, handler: @escaping (Result<Plan, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId) else {
            print("error...")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let plan = try encoder.decode(Plan.self, from: data)
                    handler(.success(plan))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    func getLocation(locationId: String, handler: @escaping (Result<Location, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/locations/" + locationId) else {
            print("error...")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let location = try encoder.decode(Location.self, from: data)
                    handler(.success(location))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    func getLocations(handler: @escaping (Result<Array<Location>, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/locations") else {
            print("error...")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let locations = try encoder.decode(Array<Location>.self, from: data)

                    handler(.success(locations))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
    
    func addDestination(planId: String, locationId: String, handler: @escaping (Result<EmptyJson, Error>) -> Void) {
        guard let url = URL(string: hostURL + "/plans/" + planId + "/0") else {
            print("error...")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let requestBody: [String: Any] = ["destination": locationId]
        let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonRequestBody
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            if let error = error {
                handler(.failure(error))
            } else {

                do {
                    let encoder = JSONDecoder()

                    // convert any snake_case to camelCase
                    encoder.keyDecodingStrategy = .convertFromSnakeCase
                    let data = data ?? Data()
                    let emptyJson = try encoder.decode(EmptyJson.self, from: data)
                    handler(.success(emptyJson))
                } catch {
                    handler(.failure(error))
                }

            }

        }

        task.resume()
    }
}
