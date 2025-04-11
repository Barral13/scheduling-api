const express = require('express');
require('dotenv').config();
const cors = require('cors'); // <--- aqui
const app = express();

app.use(cors()); // <--- aqui
app.use(express.json());

// Rotas
const authRoutes = require('./routes/authRoutes');
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando na porta ${PORT}`);
});
