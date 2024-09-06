import tkinter as tk
import pyodbc
from tkinter import ttk
from tkinter import messagebox
import datetime

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


    def show_results(self, req_results):

        # Clearing existing data in the treeview
        for record in self.tree.get_children():
            self.tree.delete(record)
        # Populating the treeview with query results
        if(req_results==[]):
            self.tree.insert("","end",values = ("","le pompier n'est plus dans la BD"))
        else:
            for result in req_results:
                self.tree.insert("", "end", values=result)

    def show_results_date(self, req_results):

        # Clearing existing data in the treeview
        for record in self.tree.get_children():
            self.tree.delete(record)
        for result in req_results:
            for x in range(len(result)):
                if(type(result[x]) == datetime.date):
                    result[x].strftime('%m/%d/%Y')
                    self.tree.insert("", "end", values=(result[x-1],result[x], result[x+1]))
class SQLViewerApp3:
    def __init__(self, root):
        self.root = root
        self.root.title("Recherche par autres critères")

        # Creating a frame to hold the widgets
        self.main_frame = ttk.Frame(root, padding="50")
        #self.main_frame.pack(fill=tk.BOTH, expand =True)
        self.main_frame.grid(row=0, column=0)

        # Connecting to SQL Server database
        self.conn = pyodbc.connect(conn_str)
        self.cursor = self.conn.cursor()

        # Creating a label and entry for SQL query input
        self.query_label_id = ttk.Label(self.main_frame, text="NAS")
        self.query_label_id.grid(row=0, column=1, sticky='')
        self.query_label_date = ttk.Label(self.main_frame, text="Date")
        self.query_label_date.grid(row=2, column=1, sticky='')
        self.query_label_quart = ttk.Label(self.main_frame, text="Quart de travail")
        self.query_label_quart.grid(row=2, column=2, sticky='')

        self.query_label = ttk.Label(self.main_frame, text="Enlever un pompier")
        self.query_label.grid(row=1, column=0, sticky=tk.W)
        self.query_entry = ttk.Entry(self.main_frame, width=10)
        self.query_entry.grid(row=1, column=1, padx=5, sticky=tk.W)

        #entry pour la date répondreIncendie
        self.query_label_2 = ttk.Label(self.main_frame, text="Entrer une date et un quart de travail")
        self.query_label_2.grid(row=3, column=0, sticky=tk.W)
        self.query_entry_2 = ttk.Entry(self.main_frame, width=10)
        self.query_entry_2.grid(row=3, column=1, padx=5, sticky=tk.W)
        self.query_entry_3 = ttk.Entry(self.main_frame, width=10)
        self.query_entry_3.grid(row=3, column=2, padx=5, sticky=tk.W)

        # Creating a button to execute the query
        self.execute_button = ttk.Button(self.main_frame, text="Delete pompier", command=self.execute_query)
        self.execute_button.grid(row=1, column=3, padx=5)

        self.execute_button_veri = ttk.Button(self.main_frame, text="Vérifie le pompier", command=self.check_delete)
        self.execute_button_veri.grid(row=1, column=4, padx=5)

        self.execute_button2 = ttk.Button(self.main_frame, text="Vérifie l'équipe", command=self.date_incendie)
        self.execute_button2.grid(row=3, column=3, padx=5)


    def display_message(self):
        messagebox.showinfo("Message", "Opération réussie!")
    def execute_query(self):
        self.cursor = self.conn.cursor()
        NAS_pompier = self.query_entry.get()
        info_delete= "Delete from Pompier where NAS = ?"
        self.cursor.execute(info_delete,(NAS_pompier))
        self.conn.commit()

        self.display_message()
        self.cursor.close()
    def check_delete(self):
        self.cursor = self.conn.cursor()
        NAS_pompier = self.query_entry.get()
        info_pompier = "select NAS, nom, prenom from Pompier where NAS = ?"
        self.cursor.execute(info_pompier, (NAS_pompier))
        rows = self.cursor.fetchall()
        new_window = tk.Toplevel(self.root)
        results_viewer = resultat_req(new_window, rows)
        results_viewer.show_results (rows)
        self.cursor.close()
    def date_incendie(self):
        self.cursor = self.conn.cursor()
        journée = self.query_entry_2.get()
        quart = self.query_entry_3.get()

        req = """select id_equipe, Horaire.journée, Horaire.quart_travail from AvoirHoraire inner join Horaire ON Horaire.id_horaire = AvoirHoraire.id_horaire
        where AvoirHoraire.id_horaire IN (select Horaire.id_horaire from Horaire where Horaire.journée = ? AND quart_travail = ?);"""

        # Executing the SQL query
        self.cursor.execute(req, (journée, quart))
        rows = self.cursor.fetchall()
        new_window = tk.Toplevel(self.root)
        results_viewer = resultat_req(new_window, rows)
        results_viewer.show_results_date((rows))
        self.cursor.close()


if __name__ == "__main__":
    root = tk.Tk()
    app = SQLViewerApp3(root)
    root.mainloop()