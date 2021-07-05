# On Demand Resource (ODR)

  On demand resources are app contents and are seperate from app bundle that are downloaded. ODR files are hosted on apple servers when an app is submited to app strore or coustom hosting (your server) for internal development (or Ad Hoc) testing or an enterprise application.

  Benefits of ODR are 
  - smaller app size
  - lazy loading of app resources
  - remote storage of rarely used resources 
  - remote storage of in-app purchase resources. 
  The resources type can be of any format like images, Data file(eg: pdf, compressed and more), sprite kit (particle, scene, texture) **except executable swift, Objective-C, C or C++ code**. 

  This repository is only for how to host you asset packs in your local server (which means, turn your macbook-pro into local server using flask and python and share across the network on other machines). Once server is ready, our mobile app will be able to download the requested ODR resources.

**Pre-requisite:** Should be an iOS developer and familiar with ODR concept.

### Setup in iOS app:

1. Download this project (or You can copy and paste the `/odr_custom_host` folder in your application’s root folder). Open this project ->
2. In the project navigator -> Select the Target -> Build Settings -> Assets Category -> Enable On Demand Resources -> **Yes**
3. In the project navigator -> Select the Target -> Build Settings -> Assets Category -> Asset pack manifest URL prefix -> add url `http://127.0.0.1:8000/odr_files/`
4. Add tags (name) to resources. (Note: For custom hosting, only Download On Demand Resource - prefetched tag works)
5. Generate asset packs for your server by exporting an archive of your app.
6. After exporting, xcode generates app bundles and ODR asset packs. Copy these asset packs and paste into our `odr_custom_host/odr_files` folder (from point 1). Once you run your local server, iOS app should be able to download ODR files based on a tag request.

### Generate Asset packs:
- Open xcode archive from xcode -> windows -> Organiser
- Chose your archive of an app
- Select Distribute App -> select method of distribution (Ad Hoc, Enterprise or Dev) -> Next
- Select `Host on server` under On-Demand-Resources and paste the same link as provided in Asset pack manifest URL (under Build setting (check point 3)). If App thinning is selected, asset packs are generated for all iPhone and iPad devices. Click on Next and export. 
- When export is completed, xcode generates app bundles and asset packs. Asset packs are available in On demand resource folder. These asset pack follows a naming convection in following order: `{bundle-identifier}.{tag-name}.assetpack`. If Appthinning is selected, `{bundle-identifier}.{tag-name}-{app-thinning-device-type}.assetpack`.


### Set up local server: (Follow installantion guide lines to setup local server [here](https://github.com/nsandeep440/flask_restful_api/tree/flask_basic_api#installation-guilde0))
- Open terminal and navigate to `cd ../odr_custom_host` folder.
- Create virtual env and pip3 install flask and run you app (Follow installantion guide lines to [setup local server](https://github.com/nsandeep440/flask_restful_api/tree/flask_basic_api#installation-guilde0))
- Go to xcode and run iOS project. If all steps are followed, app will be able to download on-demand-resources from your local server whenever you request for a resource.

### Requesting Access:
  App must request access to tag before accessing a tagged resource. If accessed tag is already available on device, it will not download the resource. If it is ain’t, it requests for downloading with provided URL with tagNamee (eg: `http://127.0.0.1:8000/odr_files/<tag_name>`
- To request access, Initialize `NSBundleResourceRequest` with tags like this `NSBundleResourceRequest(tags: [tag], bundle: Bundle.main)`
- You can use one of the two methods to request acces:
    - 1. ```conditionallyBeginAccessingResourcesWithCompletionHandler:``` is used to check whether the resource is already available in device. Completion handler provides you a boolean to check availability of resource.
    - 2. ```beginAccessingResourcesWithCompletionHandler:``` if resource is not available, use this method to download the resource.
For more information, check `BundleRequest.swift` file in this demo project.


### Configure dev server across the network

Most of the times, we intend to test our application in mobile (real device) rather than simulator. We should be able to access our dev server in other machines. This can be acheived by adding our neetwork's ip-address in `app.py` file. Follow below steps:
1. Your Local machine (probably macbook) and other machine (probably iPhone) should be connected to same network. 
1. Go to network preferences -> copy your ip address (might be 192.168.x.x).
2. Go to `app.py` file and inside the init method replace with this code `app.run(debug=True, port=8000, host='ip-address')`
3. Restart your local server and all machines which is connect to same network will be able to access this requests.


Hope this will be clear about hosting your ODR files.
Thank you! 


