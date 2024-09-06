import tkinter as tk
import pyodbc
from tkinter import ttk
from tkinter import messagebox

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

class SQLViewerApp2:
    def __init__(self, root):
        self.root = root
        self.root.title("Recherche par equipe")

        # Creating a frame to hold the widgets
        self.main_frame = ttk.Frame(root, padding="50")
        self.main_frame.grid(row=0, column=0)

        # Connecting to SQL Server database
        self.conn = pyodbc.connect(conn_str)
        self.cursor = self.conn.cursor()

        # Creating a label and entry for SQL query input
        self.query_label_id = ttk.Label(self.main_frame, text="id_equipe")
        self.query_label_id.grid(row=0, column=1, sticky='')
        self.query_label_tel = ttk.Label(self.main_frame, text="id_caserne")

        self.query_label_tel.grid(row=0, column=2, sticky='')
        self.query_label = ttk.Label(self.main_frame, text="Entrez le id de l'équipe pour trouver les informations des pompiers")
        self.query_label.grid(row=1, column=0, sticky=tk.W)
        self.query_entry = ttk.Entry(self.main_frame, width=10)
        self.query_entry.grid(row=1, column=1, padx=5, sticky=tk.W)


        self.query_label2 = ttk.Label(self.main_frame, text="ajouter une équipe dans une caserne (par défault caserne C1)")
        self.query_label2.grid(row=2, column=0, sticky=tk.W)
        self.query_entry2= ttk.Entry(self.main_frame, width=10)
        self.query_entry2.grid(row=2, column=1, padx=5, sticky=tk.W)
        self.query_entry3= ttk.Entry(self.main_frame, width=10)
        self.query_entry3.grid(row=2, column=2, padx=5, sticky=tk.W)


        # Creating a button to execute the query
        self.execute_button = ttk.Button(self.main_frame, text="recherche pompiers", command=self.execute_query)
        self.execute_button.grid(row=1, column=3, padx=5)


        self.execute_button2 = ttk.Button(self.main_frame, text="ajouter l'équipe", command=self.ajout_equipe)
        self.execute_button2.grid(row=2, column=3, padx=5)
    def display_message(self):
        messagebox.showinfo("Message", "La caserne n'existe pas!")
    def execute_query(self):
        self.cursor = self.conn.cursor()
        id_equipe = self.query_entry.get()
        query = "Select * from Pompier where id_equipe = ?"

        # Executing the SQL query
        self.cursor.execute(query,(id_equipe))
        rows = self.cursor.fetchall()

        new_window = tk.Toplevel(self.root)
        results_viewer = resultat_req(new_window, rows)
        self.cursor.close()

    def ajout_equipe(self):
        self.cursor = self.conn.cursor()
        id_equipe = self.query_entry2.get()

        id_caserne_default = 'C1'
        id_caserne = self.query_entry3.get()
        req = "INSERT INTO Equipe (id_caserne, id_Equipe) VALUES (?, ?)"
        # Executing the SQL query
        if(id_caserne in ['C1', 'C2', 'C3']) & (int(id_equipe[1:]) not in range(1, 13)): #Examine que l'équipe n'est pas existante et la caserne existe

            self.cursor.execute(req, (id_caserne, id_equipe))
            self.conn.commit()

            req2 ="select * from Equipe "
            self.cursor.execute(req2)
            rows = self.cursor.fetchall()

            new_window = tk.Toplevel(self.root)
            results_viewer = resultat_req(new_window, rows)
            self.cursor.close()
        else:
            self.display_message()

if __name__ == "__main__":
    root = tk.Tk()
    app = SQLViewerApp2(root)
    root.mainloop()