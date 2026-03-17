import express from "express";
import dotenv from "dotenv";

dotenv.config({
	path: ".env.dev"
});

const app = express();

const port = process.env.port || 3000;

app.get("/", (req, res) => {
	res.send("Branchify backend is running......")
})


app.listen(port, () => {
	console.log(`Server is running on => http://localhost:${port}`)
})
