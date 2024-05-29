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
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let bottomBarView = BottomBarView()


    private let temporaryContentView = UIView()
    private let showDelailsButton = UIButton()

    var viewModel: CityWeatherViewModelInput!
    var dataSource: [Section] = []

    // MARK: Lifecycle
    override func setup() {
        super.setup()
        
        view.backgroundColor = .white

        setupBackgroundImage()
        setupTitleContainer()
        setupTitleView()
        setupTableView()
        setupBottomBarView()

        viewModel.output = self
        viewModel.viewDidLoad()
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

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self

        tableView.registerCell(TitleCell.self)
        tableView.registerCell(DayHourlyWeatherCell.self)
        tableView.registerCell(DayWeatherCell.self)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleContainer.snp.bottom)
            make.horizontalEdges.equalToSuperview()
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
            make.top.equalTo(tableView.snp.bottom)
        }
    }

    private func presentCityWeatherDetailedViewController(with weatherData: MOCKData?) {
        let detailsViewController = CityWeatherDetailedViewController()
        let navigationController = BaseNavigationController(rootViewController: detailsViewController)
        detailsViewController.setupNavigationBar(
            withTitle: "Weather conditions",
            andIcon: UIImage(systemName: "cloud.sun.fill")
        )
        present(navigationController, animated: true)
    }

    // MARK: Public methods
    func setup(_ data: MOCKData) {
        titleView.setup(data.titleData)
    }
}

// MARK: - UITableViewDataSource
extension CityWeatherViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.section].items[indexPath.row]

        let cell: UITableViewCell

        switch item {
        case .title(let data):
            cell = tableView.dequeue(TitleCell.self, for: indexPath)
            (cell as? TitleCell)?.setup(data)
        case .dayHourlyWeather(let data):
            cell = tableView.dequeue(DayHourlyWeatherCell.self, for: indexPath)
            (cell as? DayHourlyWeatherCell)?.setup(data)
        case .dayWeather(let data):
            cell = tableView.dequeue(DayWeatherCell.self, for: indexPath)
            (cell as? DayWeatherCell)?.setup(data)
        }

        cell.selectionStyle = .none
        cell.backgroundColor = .waLightBlue.withAlphaComponent(0.9)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CityWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        presentCityWeatherDetailedViewController(with: nil)
    }
}

// MARK: - CityWeatherViewModelOutput
extension CityWeatherViewController: CityWeatherViewModelOutput {
    func setupTitle(with data: TitleView.InputModel) {
        titleView.setup(data)
    }

    func reloadData() {
        tableView.reloadData()
    }
}
