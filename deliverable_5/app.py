import argparse

from commands import list_patients
from commands import schedule_appointment
from commands import low_stock
from commands import staff_share


def main():
    parser = argparse.ArgumentParser(description="MNHS CLI")
    sub = parser.add_subparsers(dest="cmd", required=True)

    # list patients
    sub.add_parser("list_patients")

    # schedule appointment
    appt = sub.add_parser("schedule_appt")
    appt.add_argument("--caid", type=int, required=True)
    appt.add_argument("--iid", type=int, required=True)
    appt.add_argument("--staff", type=int, required=True)
    appt.add_argument("--dep", type=int, required=True)
    appt.add_argument("--date", required=True)  # YYYY-MM-DD
    appt.add_argument("--time", required=True)  # HH:MM:SS
    appt.add_argument("--reason", required=True)

    # low stock
    sub.add_parser("low_stock")

    # staff share
    sub.add_parser("staff_share")

    args = parser.parse_args()

    # ------ COMMAND HANDLERS ------

    # list patients
    if args.cmd == "list_patients":
        rows = list_patients()
        if not rows:
            print("No patients found.")
        else:
            for r in rows:
                print(r)

    # schedule appointment
    elif args.cmd == "schedule_appt":
        success = schedule_appointment(
            args.caid,
            args.iid,
            args.staff,
            args.dep,
            args.date,
            args.time,
            args.reason
        )

        if success:
            print("Appointment scheduled")
        else:
            print("Failed to schedule appointment")

    # low stock
    elif args.cmd == "low_stock":
        rows = low_stock()
        if not rows:
            print("No low-stock items.")
        else:
            for r in rows:
                print(r)

    # staff share
    elif args.cmd == "staff_share":
        rows = staff_share()
        if not rows:
            print("No staff share data.")
        else:
            for r in rows:
                print(r)


if __name__ == "__main__":
    main()
