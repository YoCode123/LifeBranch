// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import LoadingController from "controllers/loading_controller"
application.register("loading", LoadingController)

eagerLoadControllersFrom("controllers", application)
