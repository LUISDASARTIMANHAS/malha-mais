---
name: malha-fitness-app
description: Comprehensive assistant skill for developing the MALHA intelligent fitness mobile app in Flutter. Use when implementing UI screens (Dashboard, Workouts/Register Activity, Analytics, Profile), design system (Dark mode, neon green #C5F52B, purple #843CFF, emerald #22D98B), automatic calculations, gamification rules, scoring, diminishing returns, leaderboards, and AI coach architecture.
---
# MALHA Fitness App Development Assistant

You are an expert AI collaborator and Flutter/Full-stack developer guiding the creation and implementation of **MALHA** — an intelligent fitness training platform combining evolution, competition, and personalization.

## 1. Visual Identity & Design System
- **Theme**: Dark Mode (Mobile-first, premium, technological aesthetic)[cite: 1, 6]. Fundo estritamente escuro, sem suporte a modo claro/branco[cite: 6].
- **Background**: `#080A14` (quase preto com manchas suaves de luz roxa e verde)[cite: 1, 6].
- **Cards & Containers**: `#111523` (azul-marinho muito escuro, bordas arredondadas ~18px, leve transparência e glow)[cite: 1, 6].
- **Primary Neon**: Neon Green `#C5F52B` (cor principal para estados selecionados, navegação ativa, passos e botões)[cite: 1, 3, 4, 5, 6].
- **Secondary Neon**: Purple `#843CFF` (cor secundária para tempo ativo, exercícios dinâmicos e destaques)[cite: 1, 4, 5, 6].
- **Positive Indicator**: Emerald Green `#22D98B` (indicadores positivos, anéis de calorias, sucesso)[cite: 1, 4, 5, 6].
- **Typography**: Clean, modern (Inter / SF Pro style)[cite: 6].

---

## 2. Architecture & 4-Tab Persistent Navigation
O aplicativo possui uma barra de navegação inferior persistente com 4 abas principais[cite: 1, 3, 4, 5, 6]:
1. **Dashboard (Home)**:
   - Header com saudação personalizada ("Good morning, Madina! 👋"), subtítulo, notificações e avatar do usuário[cite: 6].
   - **Daily Progress**: 3 anéis circulares de progresso lado a lado (Calorias: 1.850/2.200 Kcal, Passos: 8.420/10.000, Tempo Ativo: 45 min) com cores e ícones individuais[cite: 6].
   - **Heart Rate Card**: Frequência cardíaca atual (78 BPM) com gráfico de linha em neon verde-amarelado (00:00 às 24:00) e indicador flutuante[cite: 6].
   - **Activity Summary Card**: Mini-cards horizontais para Distância (2.4 km), Calorias Ativas (310 Kcal) e Sono (7h 32m)[cite: 6].
2. **Workouts / Register Activity**:
   - Header com botão de voltar, "Register Activity", ícone de histórico e subtítulo[cite: 2].
   - Seletor de Modalidade: Running, Cycling, Weight Training, Dynamic Exercises (com destaque em verde neon na selecionada)[cite: 2].
   - Origem da Atividade: Manual Entry vs Device / GPS Data[cite: 2].
   - **Formulários e Cálculos Automáticos**:
     - *Corrida / Ciclismo*: Campos de Data, Distância (km), Duração (min:sec), Frequência Cardíaca e Calorias opcionais[cite: 2]. **Cálculos automáticos**: Velocidade Média ($km/h$) e Ritmo Médio/Pace ($min/km$)[cite: 2].
     - *Musculação*: Seleção de exercícios, séries, repetições, peso (kg), tempo de descanso e duração[cite: 2]. **Cálculo automático**: Volume total levantado ($\sum \text{Séries} \times \text{Repetições} \times \text{Carga}$)[cite: 2].
     - *Exercícios Dinâmicos*: Flexões, abdominais, agachamentos, burpees (repetições, séries, duração)[cite: 2].
   - **Workout Summary Card**: Resumo em tempo real antes de salvar[cite: 2].
   - **Histórico e Gestão**: Consulta de registros anteriores, edição e exclusão de entradas manuais[cite: 2].
3. **Analytics**:
   - Seletor de Período: Week (padrão) vs Month[cite: 4, 5].
   - **This Week Overview**: Gráfico de barras agrupadas de segunda a domingo para 3 séries: Passos (Verde Neon), Calorias Ativas (Verde Esmeralda) e Tempo Ativo (Roxo)[cite: 4, 5].
   - **Achievements**: Emblemas hexagonais estilo videogame com brilho (ex: "Streak 7 Days" com gradiente verde e "Burn 10K Calories" com gradiente roxo)[cite: 4, 5].
   - **Personal Records**: Cards horizontais para Most Steps, Longest Run e Most Calories com datas e valores em destaque[cite: 4, 5].
4. **Profile**:
   - Header com "My Profile" e ícone de configurações[cite: 3].
   - Destaque do Usuário: Avatar circular, Nome (Madina), Email, Badge "Premium Member" e botão "Edit Profile"[cite: 3].
   - **Personal Information**: Idade (28 anos), Gênero (Feminino), Altura (165 cm), Peso (62 kg), Peso Meta (58 kg)[cite: 3].
   - **Fitness Goals**: Passos diários (10k), Calorias diárias (2.200), Treinos semanais (5), Tempo ativo diário (45 min) com barras de progresso[cite: 3].
   - **Workout Preferences**: Alternância de modalidades (Running, Cycling, Weight Training, Yoga)[cite: 3].
   - **Settings & Logout**: Dados pessoais, notificações, privacidade, dispositivos conectados, unidades (Métrico/Imperial), suporte e saída da conta com confirmação[cite: 3].

---

## 3. Gamification, Scoring & Business Rules
- **Score & Pontos**: Concedidos com base em duração, volume, distância, dificuldade e consistência[cite: 7].
- **Retorno Decrescente por Repetição**: Mecanismo antifraude que reduz os pontos adicionais ao repetir exercícios idênticos em excesso na mesma janela de tempo (1.ª: 100% $\rightarrow$ 2.ª: 70% $\rightarrow$ 3.ª: 40% $\rightarrow$ Demais: 20%)[cite: 7].
- **Títulos de Progressão**: Progressão humorística e gamificada: *Sedentário* $\rightarrow$ *Sarado* $\rightarrow$ *John Cena*[cite: 7].
- **Single-player & Multiplayer**: Metas pessoais que alimentam o progresso global. Desafios diários, semanais, mensais e rankings Top 10 (participação opcional)[cite: 7].

---

## 4. AI Coach Integration (Agente de IA)
- Treinador virtual combinando **Motor de Regras** (validação de limites e segurança), **Sistema de Recomendação** (análise de histórico e aderência) e **Modelo de Linguagem** (geração de planos de treino personalizados, explicações de progresso e períodos de recuperação)[cite: 7].
- Conversão de objetivos genéricos em metas mensuráveis apresentadas como propostas para revisão e aceitação do usuário[cite: 7].