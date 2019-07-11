//
//  ViewController.swift
//  MyMap
//
//  Created by iwama on 2019/07/12.
//  Copyright © 2019 iwama. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        inputText.delegate = self
    }

    @IBOutlet weak var inputText: UITextField!
    
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        // 入力された文字を取り出す
        if let searchKey = textField.text {
            print(searchKey)
            
            let geocoder = CLGeocoder()
            
            // 入力された文字から位置情報を取得
            geocoder.geocodeAddressString(searchKey, completionHandler: {(placemarks, error) in
                if let unwrapPlacemarks = placemarks {
                    // 1件目の情報を取り出す
                    if let firstPlacemark = unwrapPlacemarks.first {
                        // 位置情報を取り出す
                        if let location = firstPlacemark.location {
                            // 位置情報から緯度経度を取り出す
                            let targetCoordinate = location.coordinate
                            print(targetCoordinate)
                            
                            // ピン生成
                            let pin = MKPointAnnotation()
                            // ピンを置く場所に緯度経度を設定
                            pin.coordinate = targetCoordinate
                            pin.title = searchKey
                            // ピンを地図に置く
                            self.dispMap.addAnnotation(pin)
                            
                            // 緯度経度を中心にして半径500m以内を表示
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                            
                        }
                    }
                }
            })
            
        }
        return true
    }
    
}

