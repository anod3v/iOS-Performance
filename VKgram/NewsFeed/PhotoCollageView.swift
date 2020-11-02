import UIKit

class PhotoCollageView: UIView {
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var collectionView: UICollectionView = {
        let layout = PhotosCollageLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .blue
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let cellID = "PhotoCollageCollectionViewCell"
    
    var photos = [String]()
    
    let noImageLink = "https://lh3.googleusercontent.com/i1ntSY7ACWnaxtdxI0KO9vHh0UNtXRin1YNnSVCpfmE5JH9752u4tFLyd-gWM9Hi-zyASAW8lYXnNvLfT7LHJUVJOgjAqbA74b0-m-UU8XdZSiFnTnYRADTmRVyXOiprgp0TsiGv=w2400"
    
//    var post = Post()
//        { didSet { print("postNo did change to:\(post.postNo)") } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
//        let bundle = Bundle(for: type(of: self))
//        bundle.loadNibNamed("PhotoCollageView", owner: self, options: nil)
//        print("photoCollage has been init-zed")
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .red
        contentView.pin(to: self)
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCollageCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
//        collectionView.collectionViewLayout = PhotosCollageLayout()
        collectionView.pin(to: contentView)
        
        
    }
    
//    private func initCollectionView() {
//        collectionView.pin(to: self)
//        collectionView.collectionViewLayout = PhotosCollageLayout()
//    }
}

extension PhotoCollageView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch photos.count {
        case 0:
            photos = [noImageLink]
            return photos.count
        case 1, 2:
            return photos.count
        case 3:
            return 4
        default:
            return 4
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? PhotoCollageCollectionViewCell else {
            fatalError("can't dequeue \(cellID)")
        }
        
        let index = indexPath.row + 1
        let numberOfExtraPhotos = photos.count - 4
        var labelText = String()
        
        if numberOfExtraPhotos > 0 {
            labelText = "+\(numberOfExtraPhotos)"
        }
        
        switch index {
        case 1, 2, 3:
            cell.configure(for: photos[indexPath.row])
        case 4:
            if photos.indices.contains(indexPath.row) {
                cell.configureEmptyCell(for: photos[indexPath.row], labelText: labelText)
            } else {
                cell.configureEmptyCell(for: photos.last!, labelText: labelText)
            }
        default:
            cell.configure(for: photos[indexPath.row])
        }

        return cell
    }
}
