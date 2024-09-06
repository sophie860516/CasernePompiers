import tkinter as tk
import pyodbc
from tkinter import ttk

conn_str = (
    "Driver=ODBC Driver 17 for SQL Server;"
    "Server=localhost;"
    "Database=CasernePompier1;"
    "Encrypt=yes;"
    "TrustServerCertificate=yes;"
    "Trusted_Connection=yes;"
)

class resultat_req:
    def __init__(self, root, req_results):
        self.root = root
        self.root.title("Résultats")
        # Creating a treeview to display the query results
        self.tree = ttk.Treeview(self.root, columns=("id", "nom", "tel"), show="headings")
        # self.tree.grid(row=1,column=0,columnspan=3)
        self.tree.column("id", width=200)
        self.tree.column("nom", width=200)
        self.tree.column("tel", width=200)
        self.tree.heading("id")
        self.tree.heading("nom", text="Résultat de la requête")
        self.tree.heading("tel")
        self.tree.grid(row=3, column=0, columnspan=1, padx=5, sticky=' ')

        self.show_results (req_results)

    def show_results(self, req_results):

        # Clearing existing data in the treeview
        for record in self.tree.get_children():
            self.tree.delete(record)
        # Populating the treeview with query results
        if (req_results ==[]):
            self.tree.insert("", "end", values=("", "                 Aucun résultat"))
        else:
            for result in req_results:
                self.tree.insert("", "end", values=result)

class SQLViewerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Recherche par caserne")

        # Creating a frame to hold the widgets
        self.main_frame = ttk.Frame(root, padding="50")
        self.main_frame.grid(row=0, column=0)

        # Connecting to SQL Server database
        self.conn = pyodbc.connect(conn_str)
        self.cursor = self.conn.cursor()

        # Creating a label and entry for SQL query input
        self.query_label_id = ttk.Label(self.main_frame, text="id_caserne")
        self.query_label_id.grid(row=0, column=1, sticky='')
        self.query_label_tel = ttk.Label(self.main_frame, text="téléphone")
        self.query_label_tel.grid(row=0, column=2, sticky='')
        self.query_label = ttk.Label(self.main_frame, text="Entrez le id de la caserne pour trouver le id et le nom des secteurs couverts")
        self.query_label.grid(row=1, column=0, sticky=tk.W)
        self.query_entry = ttk.Entry(self.main_frame, width=10)
        self.query_entry.grid(row=1, column=1, padx=5, sticky=tk.W)

        self.query_label2 = ttk.Label(self.main_frame, text="Entrez le id de la caserne pour trouver ses équipes")
        self.query_label2.grid(row=2, column=0, sticky=tk.W)
        self.query_entry2= ttk.Entry(self.main_frame, width=10)
        self.query_entry2.grid(row=2, column=1, padx=5, sticky=tk.W)


        self.query_label3 = ttk.Label(self.main_frame, text="Entrez le id de la caserne et le nouveau numéro de téléphone")
        self.query_label3.grid(row=3, column=0, sticky=tk.W)
        self.query_entry3= ttk.Entry(self.main_frame, width=10)
        self.query_entry3.grid(row=3, column=1, padx=5, sticky=tk.W)
        self.query_entry4= ttk.Entry(self.main_frame, width=10)
        self.query_entry4.grid(row=3, column=2, padx=5, sticky=tk.W)

        # Creating a button to execute the query
        self.execute_button = ttk.Button(self.main_frame, text="recherche secteur", command=self.execute_query)
        self.execute_button.grid(row=1, column=3, padx=5)


        self.execute_button2 = ttk.Button(self.main_frame, text="recherche equipe", command=self.nombre_equipe)
        self.execute_button2.grid(row=2, column=3, padx=5)
        #self.execute_button.pack(padx=10, pady=10)

        self.execute_button3 = ttk.Button(self.main_frame, text = "vérifie numéro téléphone", command=self.changer_tel)
        self.execute_button3.grid(row=3, column=3, padx=5)


    def execute_query(self):
        self.cursor = self.conn.cursor()
        id_caserne = self.query_entry.get()
        query = "Select id_secteur, Nom_secteur from Secteur where id_caserne = ?"

        # Executing the SQL query
        self.cursor.execute(query, (id_caserne))
        rows = self.cursor.fetchall()
        new_window = tk.Toplevel(self.root)
        results_viewer = resultat_req(new_window, rows)
        self.cursor.close()

    def nombre_equipe(self):
        self.cursor = self.conn.cursor()
        id_caserne = self.query_entry2.get()
        req = "SELECT id_equipe from Equipe where id_caserne = ?"
        # Executing the SQL query
        self.cursor.execute(req, (id_caserne))
        rows = self.cursor.fetchall()
        new_window = tk.Toplevel(self.root)
        results_viewer = resultat_req(new_window, rows)
        self.cursor.close()
    def changer_tel(self):
        self.cursor = self.conn.cursor()
        nouv_tel = self.query_entry4.get()
        id_caserne = self.query_entry3.get()

        if(nouv_tel != ""):
            req = "UPDATE Caserne SET Num_tel = +? WHERE id_caserne = ?"
            self.cursor.execute(req, (nouv_tel, id_caserne))
            self.conn.commit()

            see_update = "SELECT id_caserne, Num_Tel FROM Caserne WHERE id_Caserne = ?"
            self.cursor.execute(see_update, (id_caserne))
            rows = self.cursor.fetchall()

            new_window = tk.Toplevel(self.root)
            results_viewer = resultat_req(new_window, rows)
            self.cursor.close()
        else: #vérifier le numéro telephone actuel
            avant_change = "SELECT id_caserne, Num_Tel FROM Caserne WHERE id_Caserne = ?"
            self.cursor.execute(avant_change, (id_caserne))
            rows = self.cursor.fetchall()
            new_window = tk.Toplevel(self.root)
            results_viewer = resultat_req(new_window, rows)
            self.cursor.close()

if __name__ == "__main__":
    root = tk.Tk()
    app = SQLViewerApp(root)
    root.mainloop()
