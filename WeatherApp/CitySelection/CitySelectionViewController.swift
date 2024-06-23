//
//  CitySelectionViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 08.05.2024.
//

import UIKit
import SnapKit

protocol CitySelectionViewControllerDelegate {
    func sceneDidEnterBackground()
    func sceneWillEnterForeground()
}

final class CitySelectionViewController: BaseViewController {
    typealias Section = CitySelectionViewModel.Section
    typealias Item = CityWeatherData

    // MARK: Properties
    private var collectionView: UICollectionView!
    private let unitSelectionView = UnitSelectionView()

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var snapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil

    private var presentedCityID: Int?

    var viewModel: CitySelectionViewModelInput?
    var sections: [Section] = [] {
        didSet {
            reloadDataSource()
            setupDataToPresentedViewController()
        }
    }

    // MARK: Lifecycle
    override func setup() {
        super.setup()

        view.backgroundColor = .black
        title = "Weather"

        viewModel?.output = self

        setupNavigationBar()
        setupUnitSelectionView()
        setupCollectionView()

        createDataSource()
        reloadDataSource()

        presentCityWeather(with: sections.first?.items.first ?? .emptyData, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height {
            unitSelectionView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(statusBarHeight + 50)
            }
        }
    }

    // MARK: Setup UI
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        let citySearchViewController = CitySearchViewController()
        citySearchViewController.viewModel = CitySearchViewModel()
        citySearchViewController.delegate = self
        let searchController = UISearchController(searchResultsController: citySearchViewController)
        searchController.searchResultsUpdater = citySearchViewController
        searchController.searchBar.searchTextField.placeholder = "Search city or airport"
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(systemName: "list.bullet"),
                                            for: .bookmark,
                                            state: .normal)
        searchController.searchBar.delegate = self
        searchController.showsSearchResultsController = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonAction)
        )
    }

    private func setupUnitSelectionView() {
        navigationController?.view.addSubview(unitSelectionView)
        unitSelectionView.isHidden = true
        unitSelectionView.delegate = self

        unitSelectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().inset(16)
        }
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())

        view.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self

        collectionView.registerCell(CityViewCell.self)
        collectionView.registerView(InfoFooter.self, ofKind: UICollectionView.elementKindSectionFooter)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }

    // MARK: Private methods
    func reloadDataSource() {
        snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource?.apply(snapshot)
    }

    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return UICollectionViewCell() }

            let item = sections[indexPath.section].items[indexPath.row]
            let cell = collectionView.dequeueCell(CityViewCell.self, for: indexPath)
            cell.setup(item.titleData)
            return cell
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return nil }

            switch kind {
            case UICollectionView.elementKindSectionFooter:
                let sectionFooter = collectionView.dequeueView(InfoFooter.self, ofKind: kind, for: indexPath)
                sectionFooter.setup(sections[indexPath.section].footerAttributedString)
                sectionFooter.linkAction = { [self] url in
                    self.presentWebView(with: url, title: "Meteorological data")
                }
                return sectionFooter
            default:
                return nil
            }
        }
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [self] sectionIndex, _ in
            return createCitySection()
        }

        return layout
    }

    private func createCitySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(120)
        )
        let layoutGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(50)
        )
        let layoutSectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        layoutSection.boundarySupplementaryItems = [layoutSectionFooter]
        layoutSection.interGroupSpacing = 12

        return layoutSection
    }

    private func presentCityWeather(with data: CityWeatherData?, animated: Bool = true) {
        let viewController = CityWeatherViewController()
        let viewModel = CityWeatherViewModel()
        if let data { viewModel.setup(data) }
        viewController.viewModel = viewModel
        viewController.cityID = data?.id
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated)

        self.viewModel?.getForecastForCity(with: data?.id)
    }

    private func setupDataToPresentedViewController() {
        DispatchQueue.main.async { [self] in
            if let presentedCityWeatherController = presentedViewController as? CityWeatherViewController,
               let weatherData = sections.first?.items,
               let data = weatherData.first(where: { $0.id == presentedCityWeatherController.cityID }) {

                if data.dayHourlyData == nil {
                    viewModel?.getForecastForCity(with: data.id)
                } else {
                    presentedCityWeatherController.viewModel.setup(data)
                }
            }
        }
    }

    @IBAction private func rightBarButtonAction() {
        unitSelectionView.isHidden.toggle()
    }

    // MARK: Public methods
    func sceneWillEnterForeground() {
        viewModel?.getWeatherForCityList()
    }
}

// MARK: - UISearchBarDelegate
extension CitySelectionViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarBookmarkButtonClicked")
    }
}

// MARK: - UnitSelectionViewDelegate
extension CitySelectionViewController: UnitSelectionViewDelegate {
    func didSelectUnit(_ unit: TempUnit) {
        unitSelectionView.isHidden = true
        
        print("Selected unit -", unit.unitLabel)
    }
    
    func showUnitInfo() {
        unitSelectionView.isHidden = true

        presentWebView(with: URL(string: "https://meteoinfo.ru/t-scale"), title: "Info")
    }
}

// MARK: - UICollectionViewDelegate
extension CitySelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCity = sections[indexPath.section].items[indexPath.row]
        presentCityWeather(with: selectedCity)
    }
}

// MARK: - CitySelectionViewModelOutput
extension CitySelectionViewController: CitySelectionViewModelOutput {}

// MARK: - CitySearchViewControllerDelegate
extension CitySelectionViewController: CitySearchViewControllerDelegate {
    func add(_ city: CityData) {
        navigationItem.searchController?.searchBar.text = nil
        viewModel?.getWeather(for: city)
//        viewModel?.getWeatherForCityList(forced: true)
    }
}

