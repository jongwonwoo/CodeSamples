//
//  ViewController.swift
//  Tableview
//
//  Created by 우종원 on 2020/12/03.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myTableView: MyTableView!
    private var rowCount = 5
    
    private var visibleHeaders: [UIView] = [UIView]()
    private var fixedHeader: UIView?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.register(MyTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        visibleHeaders.append(view)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let index = visibleHeaders.firstIndex(where: { $0.tag == view.tag }) {
            visibleHeaders.remove(at: index)
        }
    }
}

extension ViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 50
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        header.backgroundColor = .orange
        header.tag = section
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowCount += 1
        myTableView.reloadData { [weak self] in
            self?.updateFixedHeaderDisplay()
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateFixedHeaderDisplay()
    }
    
    private func updateFixedHeaderDisplay() {
        self.visibleHeaders.forEach { header in
            let headerOriginalFrame = self.myTableView.rectForHeader(inSection: header.tag)
            let headerCurrentFrame = header.frame
//            print(">>>>>>> header \(header.tag) OriginalFrame \(headerOriginalFrame)")
//            print(">>>>>>> header \(header.tag) CurrentFrame  \(headerCurrentFrame)")
            let fixed = headerOriginalFrame != headerCurrentFrame
            if fixed {
                if header != self.fixedHeader {
                    self.fixedHeader?.backgroundColor = .orange
                    header.backgroundColor = .blue
                    self.fixedHeader = header
                }
            } else {
                if header == self.fixedHeader {
                    self.fixedHeader?.backgroundColor = .orange
                    self.fixedHeader = nil
                }
            }
        }
    }
}

final class MyTableView: UITableView {
    private var onReloadDataCompletion: (()->Void)?
    
    func reloadData(withCompletion completion: @escaping ()->Void) {
        onReloadDataCompletion = completion
        
        reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        onReloadDataCompletion?()
        onReloadDataCompletion = nil
    }
}

final class MyTableViewCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
