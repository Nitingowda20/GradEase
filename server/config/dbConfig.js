import { connect as mongoose } from "mongoose";
import dotenv from "dotenv";

dotenv.config();
const url = process.env.MONGO_DB_URL;
mongoose(url)
  .then(() => {
    console.log("MongoDB Connected.");
  })
  .catch((ex) => {
    console.log("Error while establishing db connection", ex);
  });
