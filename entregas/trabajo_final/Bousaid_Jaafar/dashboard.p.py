import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt

# Configuración de la página
st.set_page_config(page_title="Dashboard: Modelo Efectos Fijos", layout="wide")

st.title("📊 Visual Proof: Modelo de Efectos Fijos (FE)")
st.markdown("### Análisis de Transparencia en el Cono Sur")

# 1. Cargar los datos generados por tu pipeline
try:
    df = pd.read_csv("revision_final_jaafar.csv")

    # Sidebar para filtros
    st.sidebar.header("Filtros")
    paises_sel = st.sidebar.multiselect(
        "Selecciona Países:",
        options=df['ccodealp'].unique(),
        default=df['ccodealp'].unique()
    )

    # Filtrar datos
    df_filtrado = df[df['ccodealp'].isin(paises_sel)]

    # 2. Gráfico de Líneas Paralelas (Efectos Fijos)
    st.subheader("📈 Gráfico de Variación Interna")
    fig, ax = plt.subplots(figsize=(10, 5))

    for pais in paises_sel:
        data_pais = df_filtrado[df_filtrado['ccodealp'] == pais]
        ax.plot(data_pais['year'], data_pais['fe_deviation'], label=f"País {pais}", marker='o')

    ax.set_xlabel("Año")
    ax.set_ylabel("Desviación (fe_deviation)")
    ax.legend(title="Países")
    ax.grid(True, alpha=0.3)
    st.pyplot(fig)

    # 3. Mostrar Tabla de Datos
    st.subheader("📂 Datos del Modelo")
    st.dataframe(df_filtrado, use_container_width=True)

except FileNotFoundError:
    st.error("❌ No se encontró 'revision_final_jaafar.csv'. Ejecuta primero 'python pipeline.py'.")
