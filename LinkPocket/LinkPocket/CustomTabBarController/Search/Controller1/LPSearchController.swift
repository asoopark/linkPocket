//
//  LPSearchController.swift
//  LinkPocket
//
//  Created by 내 맥북에어 on 2018. 8. 13..
//  Copyright © 2018년 LP. All rights reserved.
//

import UIKit

class LPSearchController: LPParentViewController {
    
    var categorys: [LPCategoryModel] = []
    var urls: [LPLinkModel] = []
    var inSearchMode: Bool = false
    
    var mLPSearchView = LPSearchView()
    var searchBarWrapper = SearchBarContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urls = LPCoreDataManager.store.selectAllObjectFromLink() as! [LPLinkModel]
        categorys = LPCoreDataManager.store.selectAllObjectFromCategory() as! [LPCategoryModel]
        urls.sort(by: { $0.date?.compare($1.date! as Date) == .orderedAscending})
        
        self.title = ""
        
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "URL, 카테고리 이름 검색.."
        searchBar.delegate = self
            
        searchBarWrapper = SearchBarContainerView(customSearchBar: searchBar)
        searchBarWrapper.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        
        self.navigationItem.titleView = searchBarWrapper
        mLPSearchView = (Bundle.main.loadNibNamed("LPSearchView", owner: self, options: nil)?.first as? LPSearchView)!
        mLPSearchView.delegate = self
        self.view.addSubview(mLPSearchView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mLPSearchView.recentSearchReload()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBarWrapper.searchBar.endEditing(true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func FilteredReload(filteredData: [LPSearchModel]){
        mLPSearchView.FilteredReload(filteredData: filteredData)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        searchBarWrapper.frame = CGRect(x: 0, y: 0, width: size.width, height: 44)
    }
}

extension LPSearchController: LPSearchViewDelegate {
    func removeAllSearchDataBtnClicked() {
        self.AlertTwo(title: "최근 검색어 삭제", message: "최근 검색어를 모두 삭제하시겠습니까?",yes: "확인", no: "취소", yesAction: {
            DispatchQueue.main.async {
                UserDefaults.standard.removeObject(forKey: "RecentSearch")
                UserDefaults.standard.synchronize()
                self.mLPSearchView.recentSearchReload()
            }
        }) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

class SearchBarContainerView: UIView {
    let searchBar: UISearchBar
    init(customSearchBar: UISearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)
        addSubview(searchBar)
    }
    
    override convenience init(frame: CGRect) {
        self.init(customSearchBar: UISearchBar())
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
