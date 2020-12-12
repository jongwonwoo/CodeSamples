//
//  ViewController.swift
//  CarouselCollectionView
//
//  Created by 우종원 on 2020/12/10.
//

import UIKit

class ViewController: UIViewController {

    weak var carousel: CarouselView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        let carousel = CarouselView(frame: CGRect(x: 10, y: 100, width: self.view.frame.width-20, height: 300))
        self.view.addSubview(carousel)
        self.carousel = carousel
        
        carousel.items = [("hare", "0"), ("tortoise", "1"), ("ant", "2"), ("ladybug", "3"), ("leaf", "4")]
        carousel.reloadData()
    }

}

class CarouselView: UIView {
    public var items = [(String, String)]()
    
    private weak var collectionView: CarouselCollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.clipsToBounds = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = CarouselCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.red.cgColor
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: collectionView.topAnchor),
            self.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        ])
        self.collectionView = collectionView
        
        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
    }
    
    public func reloadData() {
        collectionView?.reloadData(withCompletion: {
            // 첫 번째 아이템이 보이도록...
            self.collectionView?.scrollToItem(at: IndexPath(item: self.cellIndexOfFirstItem, section: 0), at: .centeredHorizontally, animated: false)
        })
    }
}

extension CarouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CarouselView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == cellIndexOfFirstItem {
            if let leftCell = collectionView.cellForItem(at: IndexPath(item: cellIndexOfFirstItem-1, section: 0)), collectionView.bounds.contains(collectionView.convert(leftCell.center, to: collectionView)) {
                let xOfCellOfLastItem = collectionView.contentSize.width-(cell.frame.width*2)
                collectionView.contentOffset = CGPoint(x: xOfCellOfLastItem, y: 0)
                // scrollToItem를 사용하면 빠르게 스와이프할 때 다음으로 연결이 안 되는 경우가 생길 수 있다.
                // collectionView.scrollToItem(at: IndexPath(item: cellIndexOfLastItem, section: 0), at: .centeredHorizontally, animated: false)
            }
        } else if indexPath.item == cellIndexOfLastItem {
            if let rightCell = collectionView.cellForItem(at: IndexPath(item: cellIndexOfLastItem+1, section: 0)), collectionView.bounds.contains(collectionView.convert(rightCell.center, to: collectionView)) {
                let xOfCellOfFirstItem = cell.frame.width
                collectionView.contentOffset = CGPoint(x: xOfCellOfFirstItem, y: 0)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustDisplayCellCenter()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            adjustDisplayCellCenter()
        }
    }
    
    // 양끝 셀에서 힘차게 스와이프하면 셀이 가운데 안 멈추는 경우가 있다. 이 메소드는 이런 경우를 보정한다.
    private func adjustDisplayCellCenter() {
        guard let collectionView = collectionView else { return }
        
        let cell = collectionView.visibleCells.filter { collectionView.bounds.contains(collectionView.convert($0.center, to: collectionView)) }.first
        if let cell = cell {
            let collectionViewCenter = collectionView.center
            let cellCenter = collectionView.convert(cell.center, to: collectionView.superview)
            let offsetX = collectionViewCenter.x - cellCenter.x
            if offsetX != 0 {
                collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x - offsetX, y: collectionView.contentOffset.y)
            }
        }
    }
}

extension CarouselView: UICollectionViewDataSource {
    
    private var cellCount: Int {
        guard items.count > 1 else {
            return items.count
        }
        
        return items.count + 2
    }

    private var firstCellIndex: Int {
        return 0
    }
    
    private var lastCellIndex: Int {
        return items.count + 1
    }
    
    private var cellIndexOfFirstItem: Int {
        return 1
    }
    
    private var cellIndexOfLastItem: Int {
        return items.count
    }

    private func itemIndex(withCellIndex cellindex: Int) -> Int {
        guard items.count > 1 else {
            return cellindex
        }
        
        var result = 0
        if cellindex == firstCellIndex {
            result = items.count - 1
        } else if cellindex == lastCellIndex {
            result = 0
        } else {
            result = cellindex - 1
        }
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
        let item = items[itemIndex(withCellIndex: indexPath.item)]
        cell.symbolAndTitle = (item.0, "item index:\(item.1)\ncell Index:\(indexPath.item)")
        return cell
    }
}


class CarouselCollectionView: UICollectionView {
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

class CarouselCollectionViewCell: UICollectionViewCell {
    static var identifier: String = "CarouselCollectionViewCell"
    
    public var symbolAndTitle: (String, String)? {
        didSet {
            setNeedsLayout()
        }
    }
    
    private weak var imageView: UIImageView?
    private weak var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.contentView.backgroundColor = .white
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: imageView.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ])
        self.imageView = imageView
        
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: label.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: label.trailingAnchor)
        ])
        self.titleLabel = label
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView?.image = nil
        titleLabel?.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let symbolAndTitle = self.symbolAndTitle {
            imageView?.image = UIImage(systemName: symbolAndTitle.0)
            titleLabel?.text = symbolAndTitle.1
        }
    }
}
