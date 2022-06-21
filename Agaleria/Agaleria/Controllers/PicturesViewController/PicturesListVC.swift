//
//  ViewController.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 02/06/2022.
//

import UIKit
import Lottie
class PicturesListVC: UIViewController {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var picturesTableView: UITableView!
    private var imageViewerVC: ImageViewerVC?
    //MARK: - DataMemebers
    private var picturesViewModel = PicturesViewModel()
    var floatingButton: UIButton!
    let network = NetworkUtility.sharedInstance
    let refreshControl = UIRefreshControl()
    var isPullToRefresh = false
    var gifView : AnimationView!
    //MARK: - setting up viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavbar()
        setUpViews()
        configureTableView()
        configureNetworkNotifiers()
        configureNib()
        fetchData()
        
        if NetworkUtility.sharedInstance.reachability.connection == .unavailable{
            configureNoInternetView()
        }
        
    }
    
    //MARK: - setting up Navbar
    func setUpNavbar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Agaleria - Photos"
    }
    
    //MARK: - setting up views
    func setUpViews(){
        createFloatingButton()
        refreshControl.addTarget(self, action:  #selector(refreshData), for: .valueChanged)
        
    }
    
    //MARK: - setting up delegate and datasource for tableviews
    func configureTableView() {
        picturesTableView.delegate = self
        picturesTableView.dataSource = self
        picturesTableView.separatorStyle = .none
        picturesTableView.isUserInteractionEnabled = false
        picturesTableView.refreshControl = refreshControl
    }
    
    //MARK: - Attaching nibs files to the viewcontroller
    func configureNib(){
        picturesTableView.register(UINib(nibName: NIBs.PictureCell, bundle: nil), forCellReuseIdentifier: Indentifiers.PicturesCell)
        picturesTableView.register(UINib(nibName: NIBs.ShimmerCell, bundle: nil), forCellReuseIdentifier: Indentifiers.ShimmerCell)
        
    }
    
    //MARK: - setting up network notifiers
    func configureNetworkNotifiers(){
        network.reachability.whenUnreachable = { _ in
            AlertView.showWith(message: K.NO_INTERNET, icon: UIImage(systemName: "wifi.slash") ?? UIImage())
        }
        
        network.reachability.whenReachable = { _ in
            AlertView.showWith(message: K.CONNECTED_INTERNET, icon: UIImage(systemName: "wifi") ?? UIImage())
            if let viewWithTag = self.view.viewWithTag(100) { viewWithTag.removeFromSuperview()}
            self.picturesTableView.isHidden = false
            self.floatingButton.isHidden = false
            self.fetchData()
        }
    }
    
    //MARK: - Action to handle Pull To Refresh
    @objc func refreshData() {
        isPullToRefresh = true
        self.view.isUserInteractionEnabled = false
        fetchData()
    }
    
    //MARK: - End Refresh after reload
    private func endViwRefreshing(){
        if isPullToRefresh {
            self.refreshControl.endRefreshing()
            self.view.isUserInteractionEnabled = true
            isPullToRefresh = false
        }
    }
    
    //MARK: - Request viewModel to fetch data from API
    func fetchData() {
        picturesViewModel.delegate = self
        picturesViewModel.fetchPictures()
    }
}


//MARK: - TableView delegate Methods

extension PicturesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picturesViewModel.pictures?.count ?? 0 > 0 ? picturesViewModel.pictures?.count ?? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if picturesViewModel.pictures?.count ?? 0 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: Indentifiers.ShimmerCell) as! ShimmerCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Indentifiers.PicturesCell) as! PictureTableViewCell
            if let picture = picturesViewModel.pictures?[indexPath.row] {
                cell.configure(model: picture)
            }
            cell.delegate = self
            cell.currentIndex = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (picturesViewModel.pictures?.count ?? 0) - 2 {
            picturesViewModel.fetchPictures()
        }
    }
    
}

//MARK: - ViewModel delegate Methods
extension PicturesListVC: PicturesViewModelProtocol {
    func updateViewWithData() {
        if isPullToRefresh { self.endViwRefreshing() }
        picturesTableView.isUserInteractionEnabled = true
        self.picturesTableView.reloadData()
    }
    
    func updateViewWithError(errorMsg: String) {
        self.endViwRefreshing()
        if errorMsg == CONST.OFFLINE{
            AlertView.showWith(message: K.SOMETHING_WENT_WRONG, icon: UIImage(systemName: "exclamationmark.triangle") ?? UIImage())
        }else if errorMsg == K.NO_INTERNET{
            AlertView.showWith(message: errorMsg, icon: UIImage(systemName: "wifi.slash") ?? UIImage())
        }
    }
}

//MARK: - TableCell delegate Methods
extension PicturesListVC: PictureTableViewCellProtocol {
    
    //MARK: - Tap on Image delegate Method
    func didTapOnImage(index: Int) {
        self.floatingButton.isHidden = true
        guard let pictures = picturesViewModel.pictures else {return}
        AppUtility.sharedInstance.reteriveCachedImage(key: pictures[index].downloadURL, completion: { [weak self] image in
            if let imageToView = image {
                if self?.imageViewerVC == nil{
                    self?.imageViewerVC = Storyboards.MAIN.instantiateViewController(withIdentifier: Controllers.IMAGEVIEWERVC) as? ImageViewerVC
                }
                self?.imageViewerVC?.modelImage = imageToView
                self?.imageViewerVC?.didDismissVC = {
                    self?.floatingButton.isHidden = false
                }
                self?.imageViewerVC?.modalPresentationStyle = .overCurrentContext
                self?.imageViewerVC?.modalTransitionStyle = .coverVertical
                self!.present(self!.imageViewerVC!, animated: true)
            }
        })
    }
    
    //MARK: - Share Image delegate Method
    func didShareButtonTap(index: Int) {
        guard let pictures = picturesViewModel.pictures else {return}
        AppUtility.sharedInstance.reteriveCachedImage(key: pictures[index].downloadURL, completion: { image in
            if let imageToShare = image {
                AppUtility.sharedInstance.showShareActivity(image: imageToShare, on: self)
            }
        })
        
    }
    
    //MARK: - Download Image delegate Method
    func didDownloadButtonTap(index: Int) {
        guard let pictures = picturesViewModel.pictures else {return}
        
        AppUtility.sharedInstance.reteriveCachedImage(key: pictures[index].downloadURL, completion: {image in
            if let imageToDownload = image {
                AppUtility.sharedInstance.saveToPhotos(image: imageToDownload, completion: { result in
                    AlertView.showWith(message: K.PHOTO_SAVED, icon: UIImage(systemName: "photo") ?? UIImage())
                    
                })
            }
        })
    }
    
}

//MARK: - Animation / Floating Action Button
extension PicturesListVC {
    
    //MARK: - setup animation view for no internet on startup
    private func configureNoInternetView(){
        picturesTableView.isHidden = true
        floatingButton.isHidden = true
        gifView = {
            let gifView = AnimationView()
            let animation = Animation.named("InternetAnimate")
            gifView.tag = 100
            gifView.contentMode = .scaleAspectFit
            gifView.animation = animation
            gifView.loopMode = .loop
            gifView.play()
            self.view.addSubview(gifView)
            gifView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                gifView.heightAnchor.constraint(equalToConstant: self.view.frame.height),
                gifView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
                gifView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                gifView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            ])
            return gifView
        }()
    }
    
    private func createFloatingButton() {
        floatingButton = UIButton(type: .custom)
        floatingButton.backgroundColor = .clear
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        constrainFloatingButtonToWindow()
        floatingButton.setImage(UIImage(named: "up-arrow"), for: .normal)
        floatingButton.addTarget(self, action: #selector(doScrollToTop(_:)), for: .touchUpInside)
    }
    
    private func constrainFloatingButtonToWindow() {
        DispatchQueue.main.async {
            guard let keyWindow = AppUtility.keyWindow,
                  let floatingButton = self.floatingButton else { return }
            keyWindow.addSubview(floatingButton)
            keyWindow.trailingAnchor.constraint(equalTo: floatingButton.trailingAnchor,
                                                constant: 20).isActive = true
            keyWindow.bottomAnchor.constraint(equalTo: floatingButton.bottomAnchor,
                                              constant: 70).isActive = true
            floatingButton.widthAnchor.constraint(equalToConstant:
                                                    50).isActive = true
            floatingButton.heightAnchor.constraint(equalToConstant:
                                                    50).isActive = true
        }
    }
    
    @IBAction private func doScrollToTop(_ sender: Any) {
        picturesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
