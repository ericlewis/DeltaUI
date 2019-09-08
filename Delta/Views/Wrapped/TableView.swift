import SwiftUI
import CoreData

class TableDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {
    var sectionTitles: [String]? = nil

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionIndexTitles(for: tableView)?[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionTitles?.firstIndex(of: title) ?? 0
    }
}

class IDK<Content: View>: UITableViewCell {
    var hosting: UIHostingController<AnyView>
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.hosting = UIHostingController(rootView: AnyView(EmptyView()))
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let view = hosting.view
        view?.backgroundColor = .clear
        contentView.addSubview(view!)
        
        view!.preservesSuperviewLayoutMargins = true
        view!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view!.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            view!.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            view!.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            view!.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(rootView: Content) {
        hosting.rootView = AnyView(rootView)
    }
}

class FetchedTableViewController<T: NSManagedObject, Content: View>: UITableView, NSFetchedResultsControllerDelegate {
    var fetchRequest: NSFetchRequest<T>
    var context: NSManagedObjectContext
    var sectionNameKeyPath: String?
    var rootView: (T) -> Content
    var hideAlpha: Bool
    
    var initialized = false
    
    lazy var diffDataSource = TableDataSource(tableView: self) { tv, indexPath, i in
        let cell = IDK<Content>(style: .default, reuseIdentifier: nil)
        cell.configure(rootView: self.rootView(self.context.object(with: i) as! T))
        return cell
    }
    
    lazy var frc: NSFetchedResultsController<T> = {
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: sectionNameKeyPath,
                                                    cacheName: nil)
        controller.delegate = self
        
        return controller
    }()
    
    init(_ fetchRequest: NSFetchRequest<T>, context: NSManagedObjectContext, style: UITableView.Style = .plain, sectionNameKeyPath: String? = nil, hideAlpha: Bool = false, rootView: @escaping (T) -> Content) {
        self.context = context
        self.fetchRequest = fetchRequest
        self.rootView = rootView
        self.hideAlpha = hideAlpha
        
        super.init(frame: .zero, style: style)
    }
    
    func initialize() {
        if initialized {
            return
        }
        
        register(IDK<Content>.self, forCellReuseIdentifier: "t")
                
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
        
        initialized = true
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        initialize()
    }
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
    typealias DataSource = UICollectionViewDiffableDataSourceReference
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        diffDataSource.sectionTitles = sectionNameKeyPath == nil || hideAlpha ? nil : snapshot.sectionIdentifiers as? [String]
        diffDataSource.apply(snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>,
                             animatingDifferences: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct TableView<T: NSManagedObject, Content: View>: UIViewRepresentable {
    var fetchRequest: NSFetchRequest<T>
    
    let sectionNameKeyPath: String?
    let content: (T) -> Content
    let tapped: ((T) -> Void)?
    let style: UITableView.Style
    
    init(_ fetchRequest: NSFetchRequest<T>, style: UITableView.Style = .plain, sectionNameKeyPath: String? = nil,  tapped: ((T) -> Void)? = nil, @ViewBuilder content: @escaping (T) -> Content) {
        self.fetchRequest = fetchRequest
        self.content = content
        self.tapped = tapped
        self.style = style
        self.sectionNameKeyPath = sectionNameKeyPath
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> FetchedTableViewController<T, Content> {
        let view = FetchedTableViewController(fetchRequest,
                                              context: context.environment.managedObjectContext,
                                              style: style,
                                              sectionNameKeyPath: sectionNameKeyPath,
                                              rootView: content)
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiViewController: FetchedTableViewController<T, Content>, context: Context) {
        uiViewController.sectionNameKeyPath = sectionNameKeyPath
        uiViewController.rootView = content
    }
    
    class Coordinator: NSObject, UITableViewDelegate {
        var parent: TableView
        
        init(_ parent: TableView) {
            self.parent = parent
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let view = tableView as! FetchedTableViewController<T, Content>
            parent.tapped?(view.frc.object(at: indexPath))
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            view.tintColor = .systemBackground
        }
    }
}
