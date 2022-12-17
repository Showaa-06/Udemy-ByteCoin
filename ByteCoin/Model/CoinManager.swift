//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
    
}

struct CoinManager {
    //Creatメソッドを実装する必要がある、オプションのデリゲートを作成
    //価格の更新を通知することができる
    var delegate: CoinManagerDelegate?
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8FE826E5-B668-4F4D-92C2-648BBCDD7E6C"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        //選択した通貨をAPIkeyとともにbaseURLの末尾に追加する
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //オプショナルバインディングを使用しurlStringから作成されたURLをアンラップする
        if let url = URL(string: urlString) {
            
            //default設定で新しいオブジェクトの作成
            let sesstion = URLSession(configuration: .default)
            let task = sesstion.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                //coinbase.ioから戻ってきたjsonデータを実際のSwiftオブジェクトに変換する必要がある
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                       
                        //delegate(ViewController)内のデレゲートメソッドを呼び呼び出すとともに必要なデータを渡す
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                        
                           
                        
                    }/// let bitcoinPrice
                    
                }///if let safeData
                //戻ってきたデータを印刷できるように文字列としてフォーマットする
                //let dataAsString = String(data: data!, encoding: .utf8)
                
                
                
            }/// let task
            
            //ビットコインのサーバーからデータを取得するタスクを開始
            task.resume()
            
        }/// if let url
        
        
    }///getCoinPrice
    
    
    
    //coinbase.ioから戻ってきたjsonデータを実際のswiftオブジェクトに変換する必要がある
    func parseJSON( _ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        
        //コインデータの構造体を用いてデータのデコードを試みる
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
            
        }
        
    }/// func parseJSON
    
    
}///struct
    
    

    
    

