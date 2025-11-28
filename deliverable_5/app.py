import argparse

from commands import list_patients
from commands import schedule_appointment
from commands import low_stock 
from commands import staff_share


def main():
    parser = argparse.ArgumentParser(description="MNHS CLI")
    sub = parser.add_subparsers(dest="cmd", required=True)
    
    sub.add_parser("list_patients")
    
    appt = sub.add_parser("schedule_appt")
    appt.add_argument("--caid", type=int, required=True)
    appt.add_argument("--iid", type=int, required=True)
    appt.add_argument("--staff", type=int, required=True)
    appt.add_argument("--dep", type=int, required=True)
    appt.add_argument("--date", required=True) # YYYY-MM-DD
    appt.add_argument("--time", required=True) # HH:MM:SS
    appt.add_argument("--reason", required=True)

    sub.add_parser("low_stock")

    sub.add_parser("staff_share")

    args = parser.parse_args()
    if args.cmd == "list_patients":
        for r in list_patients():   #i need to check if the command really returns a list. same thing for other commands
            print(r)

    elif args.cmd == "schedule_appt":
        schedule_appointment(args.caid, args.iid, args.staff, args.dep,
                             args.date, args.time, args.reason)
        print("Appointment scheduled")
    
    elif args.cmd == "low_stock":
        for r in low_stock():
            print(r)

    elif args.cmd == "staff_share":
        for r in staff_share():
            print(r)

if __name__ == "__main__":
    main()
    