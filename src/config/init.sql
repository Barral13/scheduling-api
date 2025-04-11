-- Criação do banco de dados (opcional, execute fora se necessário)
CREATE DATABASE scheduling_db;

-- Conectar ao banco (se estiver usando psql CLI)
\c scheduling_db;

-- TABELA DE USUÁRIOS
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'colaborador', 'cliente')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABELA DE SERVIÇOS (Criados por ADMIN)
CREATE TABLE IF NOT EXISTS services (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  price NUMERIC(10, 2) NOT NULL,
  created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABELA DE AGENDA DE HORÁRIOS (Disponibilidade dos colaboradores)
CREATE TABLE IF NOT EXISTS schedules (
  id SERIAL PRIMARY KEY,
  collaborator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  time TIME NOT NULL,
  available BOOLEAN DEFAULT TRUE,
  UNIQUE (collaborator_id, date, time)
);

-- TABELA DE AGENDAMENTOS (Criados por clientes)
CREATE TABLE IF NOT EXISTS appointments (
  id SERIAL PRIMARY KEY,
  client_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  collaborator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  service_id INTEGER REFERENCES services(id) ON DELETE SET NULL,
  schedule_id INTEGER REFERENCES schedules(id) ON DELETE SET NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('pendente', 'confirmado', 'cancelado', 'concluido')),
  payment_status VARCHAR(10) NOT NULL DEFAULT 'pendente' CHECK (payment_status IN ('pendente', 'pago')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TABELA DE PAGAMENTOS (Relatório de ganhos)
CREATE TABLE IF NOT EXISTS payments (
  id SERIAL PRIMARY KEY,
  appointment_id INTEGER REFERENCES appointments(id) ON DELETE CASCADE,
  amount NUMERIC(10,2) NOT NULL,
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
