//
//  CustomPhotoAlbum.swift
//  Goingnet
//
//  Created by 陳冠宇 on 2021/11/23.
//

import Foundation
import Photos
import UIKit

class CustomPhotoAlbum: NSObject {
    static let albumName = "國霖"
    static let sharedInstance = CustomPhotoAlbum()

    var assetCollection: PHAssetCollection!

    override init() {
        super.init()

        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }

        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
        }

        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }

    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }

    func createAlbum() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbum.albumName)   // create an asset collection with the album name
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                print("error \(String(describing: error))")
            }
        }
    }

    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let _: AnyObject = collection.firstObject {
            return collection.firstObject
        }
        return nil
    }

    func save(_ image: UIImage, completion: @escaping ((Bool, Error?) -> ())) {
        if assetCollection == nil {
            // if there was an error upstream, skip the save
            return
        }

        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)

        }, completionHandler: { result, error in
            completion(result, error)
        })
    }
}
