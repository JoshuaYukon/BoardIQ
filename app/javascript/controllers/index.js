import { application } from "controllers/application"

import DragController from "controllers/drag_controller"
application.register("drag", DragController)

import AiController from "controllers/ai_controller"
application.register("ai", AiController)
