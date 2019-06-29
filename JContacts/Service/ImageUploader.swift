//
//  ImageUploader.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation
import Cloudinary

enum ImageUploadError: Error {
    case noUploadURL
}

class ImageUploader {
    private let imageData: Data
    private let cloudinary: CLDCloudinary!
    
    init(data: Data) {
        imageData = data
        
        //configure cloudinary
        let config = CLDConfiguration(cloudName: Credentails.cloudinaryCloud,
                                      apiKey: Credentails.cloudinaryAPIKey)
        cloudinary = CLDCloudinary(configuration: config)
    }
    
    public func beginUpload(_ completion: @escaping (Result<String, Error>) -> () ) {
        let uploader = cloudinary.createUploader()
        uploader.upload(data: imageData, uploadPreset: "sxnl4m27", params: nil, progress: nil) { (result, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(.failure(error!))
                    return
                }
                guard
                    let json = result?.resultJson,
                    let uploadURL = json["url"] as? String
                    else {
                        completion(.failure(ImageUploadError.noUploadURL))
                        return
                }
                completion(.success(uploadURL))
            }
            
        }
    }
}
