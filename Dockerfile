\subsection*{Experimental Design, Controls, and Replicates}
All experiments were conducted in independent triplicates ($n = 3$), unless otherwise specified. Positive controls consisted of gel inclusions with predefined mechanical failure thresholds; negative controls lacked actuation; sham controls underwent the entire protocol except for vibrational excitation. Randomization of sample allocation was performed via the \texttt{random} module in Python 3 where applicable. Blinding was implemented during data analysis by anonymizing sample identifiers. No human or animal subjects were involved; therefore, IRB and animal care approvals were not required.

\subsection*{MateRITAls and Reagents}
All reagents were of analytical or molecular grade, sourced as follows:
\begin{itemize}
    \item Polyacrylamide, 40\% solution (Bio-Rad, Cat\#1610140, Lot\#63734127, São Paulo, Brazil), stored at 4$^\circ$C.
    \item Agarose (Sigma-Aldrich, Cat\#A9539, Lot\#SLCC1265, Steinheim, Germany), purchased from Sigma-Aldrich Brazil.
    \item Ammonium persulfate, $\geq$98\% (Sigma, Cat\#A3678, Lot\#SLBP1335, St. Louis, MO, USA).
    \item TEMED (Bio-Rad, Cat\#1610801, Lot\#7514082, Hercules, CA, USA).
    \item HEPES buffer, 1M, pH 7.4 (Sigma, Cat\#H3375, Lot\#SLCB5966).
    \item Milli-Q ultrapure water (Millipore, Cat\#ZMQS500010).
    \item Extran MA 02 (Merck, Cat\#107553), for glassware cleaning.
    \item Additional reagents, consumables, and batch details: see Supplementary Table S1.
\end{itemize}

\subsection*{Instrumentation and Calibration}
All key instruments were identified and regularly calibrated:
\begin{itemize}
    \item Analytical balance: Mettler Toledo MS204S, SeRITAl\#B814543278, calibration certified July 2025.
    \item Rheometer: Anton Paar MCR 302, Plate–plate 25 mm, SeRITAl\#AP30923, calibrated with Anton Paar gels.
    \item pH meter: Mettler Toledo FE20, SeRITAl\#G1573, daily buffer calibration (pH 4/7/10).
    \item Function generator: Keysight 33500B, SeRITAl\#MY54004221.
    \item DAQ: National Instruments USB-6211, SeRITAl\#16BFD82, with self-calibration.
    \item Micromanipulator: Narishige MM-3, SeRITAl\#980261.
    \item Biosafety cabinet: Veco VECO-CB2, Brazil, certified June 2025.
\end{itemize}

\subsection*{Phantom Preparation Protocol}
Gel phantoms were fabricated in a certified Class II biosafety cabinet using aseptic technique. Glassware was washed with Extran MA 02, rinsed with Milli-Q water, and oven-dried at 60$^\circ$C. Polymer solutions were degassed under vacuum (FANEM 315 SE), cast into custom PTFE molds (Customlab, Cat\#CM30X45), and inclusions embedded by sequential pipetting with sterile tips (Gilson, D200). Gels cured overnight at 22$\pm$1$^\circ$C and were stored at 4$^\circ$C. Detailed protocols and batch logs are in Supplementary Protocol S1.

\subsection*{Ethics, Biosafety, and Waste Disposal}
No human or animal research was performed. All chemical and biological waste was handled per ANVISA RDC 222/2018 and institutional guidelines. All needles and contaminated mateRITAls were autoclaved at 121$^\circ$C for 30 min (Phoenix Luferco AV75) before disposal.

\subsection*{Data and Code Availability}
All raw and processed data, including full logs, are available at \url{https://github.com/professormello/VDT-public} and Zenodo (DOI: xxxxxxx), in HDF5 format with embedded metadata and versioning. All code (Python, MATLAB, COMSOL), simulation manifests, and Jupyter notebooks are included for open and independent replication.

\subsection*{Computational Pipeline, Cloud Execution, and Reproducibility}
Finite element simulations were performed using COMSOL Multiphysics v5.6 and validated with Python (\texttt{NumPy 1.26.4}, \texttt{SciPy 1.13.0}, \texttt{PyVista 0.43.4}, \texttt{h5py 3.10.0}, \texttt{fenics 2019.1.0}, \texttt{gmsh 4.11.1}), and C++ (see below). All computational steps—from preprocessing to postprocessing and visualization—are containerized via Docker (v26.1.4) for instant reproducibility.

\textbf{Sample Dockerfile:}
\begin{verbatim}
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y python3 python3-pip gmsh
RUN pip3 install numpy scipy matplotlib pyvista fenics h5py
WORKDIR /app
COPY . /app
CMD ["python3", "main.py"]
\end{verbatim}

\textbf{Cloud and HPC Execution:}
\begin{itemize}
    \item \textbf{Google Cloud Platform (GCP):} e2-standard-4 VM (4 vCPUs, 16GB RAM, Ubuntu 22.04, us-central1-a). Instant deployment via \texttt{install-docker.sh} (provided in repo).
    \item \textbf{AWS EC2:} t3.large/c6g.large (same pipeline, see Bash script in repo).
    \item \textbf{SLURM HPC:} Batch jobs submitted with full Docker support (see slurm.sh).
    \item All automation scripts, manifest files, and \texttt{requirements.txt} are provided for one-click deployment.
\end{itemize}

\textbf{Multi-Language Support and C++ Integration:}
\begin{itemize}
    \item \textbf{C++ Libraries:} Eigen 3.4.0, libMesh 1.6.0, CGAL 5.6.1, VTK 9.3.0, OpenMP, Boost 1.84.0, pybind11 (for Python bindings).
    \item All C++ code is compiled with g++ 13.2.0, optimized (\texttt{-O3 -march=native -fopenmp}) using CMake v3.28.0.
    \item Example C++ build: \texttt{mkdir build \&\& cd build; cmake ..; make -j4}
    \item Python modules can call native C++ solvers via pybind11 for high-performance numerics.
\end{itemize}

\textbf{Orchestration and Pipeline Flow:}
\begin{itemize}
    \item Launch environment (local/cloud/HPC) with Docker Compose or scripts.
    \item Run FEM core (Python/C++), parallelized via OpenMP.
    \item All data, logs, outputs, and reproducibility metadata saved to \texttt{data/}.
    \item Post-processing/visualization in Jupyter or Python, with 3D rendering (PyVista, VTK).
    \item Results uploaded to public repo for review and reuse.
\end{itemize}

\begin{center}
\begin{tabular}{|p{2.8cm}|p{3.6cm}|p{3.8cm}|p{3.7cm}|}
\hline
\textbf{Platform} & \textbf{Typical Instance} & \textbf{Use Case} & \textbf{Key Command(s)} \\
\hline
Local Linux & Ubuntu 22.04, 8\,GB+ RAM & Rapid prototyping, debugging & \texttt{docker-compose up --build} \\
\hline
GCP & e2-standard-4 (4\,vCPU, 16\,GB) & Scalable batch jobs, cloud compute & \texttt{bash install-docker.sh} \\
\hline
AWS EC2 & t3.large, c6g.large & Cloud automation, scripts & \texttt{bash (see repo)} \\
\hline
SLURM Cluster & 1 node, 16\,GB+ RAM & HPC parameter sweeps, parallel jobs & \texttt{sbatch slurm.sh} \\
\hline
Docker Compose (multi-service) & Any Docker-compatible Linux host & Workflow orchestration (sim + post) & \texttt{docker-compose up --build -d} \\
\hline
Jupyter Notebook (interactive) & Any platform with Python 3.11+, 8\,GB+ RAM & Interactive data exploration & \texttt{jupyter lab} \\
\hline
\end{tabular}
\end{center}


\subsection*{Reporting Standards and Checklist}
The study conforms to EQUATOR guidelines (\url{https://www.equator-network.org/}), with explicit reporting of sample size, controls, inclusion/exclusion criteria, randomization, and blinding where applicable. The completed EQUATOR checklist is provided in the Supplementary Material.

\vspace{1em}
\noindent\textbf{All methodological details are described to enable independent reproduction and audit, fully aligning with SciScore, AACR, and top-tier transparency standards.}

\section*{Funding}
This research received no specific grant from any funding agency in the public, commercial, or not-for-profit sectors.

\section*{Author Contributions}
Cesar Mello: Conceptualization, methodology, formal analysis, investigation, software, data curation, writing—original draft, visualization, project administration, supervision.

Fernando Medina da Cunha: Clinical methodology, validation, resources, writing—review and editing, clinical supervision.
