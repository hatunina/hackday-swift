//
//  ViewController.swift
//  MyOkashi
//
//  Created by iwama on 2019/07/15.
//  Copyright © 2019 iwama. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Search Barのdelegate通知先を設定
        searchText.delegate = self
        // 入力のヒントになるプレースホルダを設定
        searchText.placeholder = "お菓子の名前を入力してください"
        // Table ViewのdataSourceを設定
        tableView.dataSource = self
    }

    @IBOutlet weak var searchText: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    // お菓子のリスト（タプルを配列でもつ）
    var okashiList: [(name: String, maker: String, link: URL, image: URL)] = []
    
    // 検索ボタンをクリック時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
            // デバッグエリアに出力
            print(searchWord)
            // 入力されていたらお菓子を検索
            searchOkashi(keyword: searchWord)
        }
    }
    
    // JSONのitem内のデータ構造
    struct ItemJson: Codable {
        let name: String?
        let maker: String?
        let url: URL?
        let image: URL?
    }
    
    // JSONのデータ構造
    struct ResultJson: Codable {
        let item:[ItemJson]?
    }
    
    // searchOkashiメソッド
    // 第一引数：keyword 検索したいワード
    func searchOkashi(keyword: String) {
        // お菓子の検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        // リクエストURLの組み立て
        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            return
        }
        print(req_url)
        
        // リクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        // データ転送を管理するためのセッションを生成
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        // リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            // セッション終了
            session.finishTasksAndInvalidate()
            do {
                // JSONDecoderのインスタンス取得
                let decoder = JSONDecoder()
                // 受け取ったJSONデータをパースして格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                print(json)
                
                // お菓子の情報が取得できているか確認
                if let items = json.item {
                    // お菓子のリストを初期化
                    self.okashiList.removeAll()
                    // 取得しているお菓子の数だけ処理
                    for item in items {
                        // お菓子の名前、メーカー名、掲載URL、画像URLをアンラップ
                        if let name = item.name, let maker = item.maker, let link=item.url, let image=item.image {
                            // 一つのお菓子をタプルでまとめて管理
                            let okashi = (name, maker, link, image)
                            // お菓子の配列へ追加
                            self.okashiList.append(okashi)
                        }
                    }
                    // Table Viewを更新する
                    self.tableView.reloadData()
                    
                    if let okashidbg = self.okashiList.first {
                        print("-----------")
                        print("okashiList[0] = \(okashidbg)")
                    }
                }
            } catch {
                print("エラーが出ました")
            }
        })
        // ダウンロード開始
        task.resume()
    }
    // Cellの総数を返すdatasourceメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // お菓子リストの総数
        return okashiList.count
    }
    
    // Cellの値を設定するdatasourceメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 今回表示を行う、Cellオブジェクト(1行)を取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath)
        // お菓子のタイトル設定
        cell.textLabel?.text = okashiList[indexPath.row].name
        // お菓子画像を取得
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].image) {
            // 正常に取得できた場合はUIImageで画像オブジェクトを生成してCellにお菓子画像を設定
            cell.imageView?.image = UIImage(data: imageData)
        }
        // 設定済みのCellオブジェクトを画面に反映
        return cell
    }
    
}

