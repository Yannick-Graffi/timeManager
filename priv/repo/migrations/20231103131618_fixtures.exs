defmodule TimeManager.Repo.Migrations.Fixtures do
  use Ecto.Migration


  def change do
  execute """
        INSERT INTO users (
          id, username, email, password_hash, inserted_at, updated_at, role)
        VALUES (2, 'Lars Rush','molestie.sodales@hotmail.couk', '$2b$12$C1aRRdt0rp/DJcqXvy9mPePK.xqD5H76ymAd9se/zZ7uSO2Pjkz1.', '2023-10-25 14:35:00', '2023-10-25 14:35:00', 'employee')
  """
#    execute """
#      INSERT INTO users (
#        id, username, email, password_hash, inserted_at, updated_at, role)
#      VALUES (2, 'Lars Rush','molestie.sodales@hotmail.couk', '$2b$12$C1aRRdt0rp/DJcqXvy9mPePK.xqD5H76ymAd9se/zZ7uSO2Pjkz1.', '2023-10-25 14:35:00', '2023-10-25 14:35:00', 'employee'),
#      (3, 'Whitney Lang','urna.convallis.erat@outlook.edu', '$2b$12$C1aRRdt0rp/DJcqXvy9mPePK.xqD5H76ymAd9se/zZ7uSO2Pjkz1.', '2023-10-25 14:35:00', '2023-10-25 14:35:00', 'employee'),
#      (4, 'Zahir Sanchez','odio.semper@hotmail.org', '$2b$12$C1aRRdt0rp/DJcqXvy9mPePK.xqD5H76ymAd9se/zZ7uSO2Pjkz1.', '2023-10-25 14:35:00', '2023-10-25 14:35:00', 'employee'),
#      (5, 'Kylan Hendrix','et.magnis@google.couk', '$2b$12$C1aRRdt0rp/DJcqXvy9mPePK.xqD5H76ymAd9se/zZ7uSO2Pjkz1.', '2023-10-25 14:35:00', '2023-10-25 14:35:00', 'employee'),
#      (6, 'James Castillo','est.congue@icloud.net', '$2b$12$C1aRRdt0rp/DJcqXvy9mPePK.xqD5H76ymAd9se/zZ7uSO2Pjkz1.', '2023-10-25 14:35:00', '2023-10-25 14:35:00', 'employee');
#
#      INSERT INTO clocks ("time", "status", "user_id") VALUES
#      ('2023-10-25 14:35:00', true, 1),
#      ('2023-10-09 10:31:00', true, 2),
#      ('2023-10-25 15:35:00', true, 3),
#      ('2023-10-22 18:35:00', false, 4),
#      ('2023-10-17 07:35:00', false, 5);
#
#      INSERT INTO working_times ("start", "end", "user_id") VALUES
#      ('2023-10-25 14:35:00', '2023-10-25 19:35:00', 1),
#      ('2023-10-09 10:31:00', '2023-10-09 13:35:00', 2),
#      ('2023-10-25 15:35:00', '2023-10-25 20:35:00', 3),
#      ('2023-10-22 18:35:00', '2023-10-22 23:35:00', 4),
#      ('2023-10-17 07:35:00', '2023-10-17 11:35:00', 5);
#
#      INSERT INTO teams("name", "manager_id", "inserted_at", "updated_at") VALUES
#      ('Alpha', 1, '2023-06-10', '2023-06-10'),
#      ('Bravo', 2, '2023-06-10', '2023-06-10'),
#      ('Charlie', 3, '2023-06-10', '2023-06-10'),
#      ('Delta', 4, '2023-06-10', '2023-06-10'),
#      ('Echo', 5, '2023-06-10', '2023-06-10');
#    """
  end
end
