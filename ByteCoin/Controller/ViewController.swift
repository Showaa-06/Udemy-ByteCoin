//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
     
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitcoinLabel: UILabel!

    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //デレゲートメソッドが呼ばれた時に通知を受け取るとうにできるようにする
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
    }
}


extension ViewController:  CoinManagerDelegate {
    //デレーゲートメソッドの実装を提供
    //コインマネージャーが価格を取得すると、このメソッドを呼び出し価格と通貨を呼び出し、価格と通貨を渡す
    func didUpdatePrice(price: String, currency: String) {
        
        //UIを更新するためにメインスレッドを保持する必要がある
        //(バックグラウンドのスレッドからこれを実行しようとするとアプリがクラッシュする)
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
        
    }
    
    
  //エラーの更新
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    
    
}




extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate  {
    //ピッカーに必要な列数を決定する
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //表示する通貨の数を数える
        return coinManager.currencyArray.count
    }
    
      //デレゲートメソッドpickerViewの追加  currencyArray: 通貨配列  row: 列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //currencyArrayからタイトルを選択することができる
        return coinManager.currencyArray[row]
    }
    
    //ユーザーがピッカーをスクロールした時に毎回呼び出される
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //pickerViewメソッドを更新//選択した通貨をgetCoinPrice()メソッドでCoinManagerに渡す
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
         
    }
    
    
}














