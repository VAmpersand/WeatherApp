//
//  CityWeatherViewController.swift
//  WeatherApp
//
//  Created by Viktor Prikolota on 01.05.2024.
//

import UIKit
import SnapKit

final class CityWeatherViewController: BaseViewController {
    typealias Section = CityWeatherViewModel.Section
    typealias Item = CityWeatherViewModel.Item

    // MARK: Properties
    private let backgroundImage = UIImageView()
    private let titleContainer = UIView()
    private let titleView = TitleView()
    private var collectionView: UICollectionView!
    private let bottomBarView = BottomBarView()

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var snapshot: NSDiffableDataSourceSnapshot<Section, Item>! = nil

    var viewModel: CityWeatherViewModelInput!
    var sections: [Section] = [] {
        didSet {
            reloadDataSource()
        }
    }

    // MARK: Lifecycle
    override func setup() {
        super.setup()
        
        view.backgroundColor = .white

        viewModel.output = self
        viewModel.viewDidLoad()

        setupBackgroundImage()
        setupTitleContainer()
        setupTitleView()
        setupCollectionView()
        setupBottomBarView()

        createDataSource()
        reloadDataSource()
    }

    // MARK: Setup UI
    private func setupBackgroundImage() {
        view.addSubview(backgroundImage)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.image = UIImage(named: "clearSky")

        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupTitleContainer() {
        view.addSubview(titleContainer)

        titleContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(titleContainer.snp.width).multipliedBy(0.65)
        }
    }

    private func setupTitleView() {
        titleContainer.addSubview(titleView)

        titleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self

        collectionView.registerView(WeatherViewHeader.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.registerCell(HourWeatherCell.self)
        collectionView.registerCell(DayWeatherCell.self)

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleContainer.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    private func setupBottomBarView() {
        view.addSubview(bottomBarView)
        bottomBarView.cityListButtonAction = { [weak self] in
            self?.dismiss(animated: true)
        }

        bottomBarView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(60)
            make.top.equalTo(collectionView.snp.bottom)
        }
    }

    private func presentCityWeatherDetailedViewController(with weatherData: CityWeatherData?) {
        let detailsViewController = CityWeatherDetailedViewController()
        let navigationController = BaseNavigationController(rootViewController: detailsViewController)
        detailsViewController.setupNavigationBar(
            withTitle: "Weather conditions",
            andIcon: UIImage(systemName: "cloud.sun.fill")
        )
        present(navigationController, animated: true)
    }

    // MARK: Public methods
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
            switch item {
            case .dayHourlyWeather(let data):
                let cell = collectionView.dequeueCell(HourWeatherCell.self, for: indexPath)
                cell.setup(data)
                return cell
            case .dayWeather(let data):
                let cell = collectionView.dequeueCell(DayWeatherCell.self, for: indexPath)
                cell.setup(data)
                return cell
            }
        }

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return nil }

            let section = sections[indexPath.section]
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let sectionHeader = collectionView.dequeueView(WeatherViewHeader.self, ofKind: kind, for: indexPath)
                sectionHeader.setup(imageSystemName: section.imageSystemName,
                                    title: section.title,
                                    description: section.description)
                return sectionHeader
            default:
                return nil
            }
        }
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [self] sectionIndex, _ in
            if sectionIndex == 0 {
                return createDayHourlySection()
            } else {
                return createDaySection()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 12

        layout.configuration = config
        layout.register(WeatherViewBackground.self, forDecorationViewOfKind: WeatherViewBackground.identifire)

        return layout
    }

    private func createDayHourlySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .absolute(120)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: layoutItem.layoutSize.widthDimension,
            heightDimension: .absolute(120)
        )
        let layoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(50)
        )
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        layoutSectionHeader.pinToVisibleBounds = true

        let decorationItem = NSCollectionLayoutDecorationItem.background(
            elementKind: WeatherViewBackground.identifire
        )

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        layoutSection.decorationItems = [decorationItem]
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets.bottom = 5

        return layoutSection
    }

    private func createDaySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50)
        )
        let layoutGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [layoutItem]
        )
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40)
        )
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        layoutSectionHeader.pinToVisibleBounds = true

        let decorationItem = NSCollectionLayoutDecorationItem.background(
            elementKind: WeatherViewBackground.identifire
        )

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        layoutSection.decorationItems = [decorationItem]

        return layoutSection
    }

    // MARK: Public methods
    func setup(_ data: CityWeatherData) {
        titleView.setup(data.titleData)
    }
}

// MARK: - UITableViewDelegate
extension CityWeatherViewController: UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        presentCityWeatherDetailedViewController(with: nil)
    }
}

// MARK: - CityWeatherViewModelOutput
extension CityWeatherViewController: CityWeatherViewModelOutput {
    func setupTitle(with data: TitleData) {
        titleView.setup(data)
    }

    func reloadData() {
        reloadDataSource()
    }
}
