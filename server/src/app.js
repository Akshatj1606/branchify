import express from "express";
import branchRouter from "./routes/branchRoutes.js";

const app = express();
app.use(express.json());

app.get("/", (req, res) => {
	res.json({
		serverStatus: "Running",
	});
});

// branch routes
app.use("/branch", branchRouter);

export default app;