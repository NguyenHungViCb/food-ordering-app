import { orderColors } from "../utils/orders";

const Timeline: React.FC<{
  data: { date: Date; title: string; content?: string }[];
}> = ({ data }) => {
  return (
    <div className="flex">
      <ol className="border-l border-gray-200 dark:border-gray-700 w-3/4 ml-auto h-max">
        {data.map((item) => (
          <li className="mb-10 relative min-h-[30px]" key={item.title}>
            <div className="absolute w-3 h-3 bg-gray-200 rounded-full mt-1.5 -left-1.5 border border-white dark:border-gray-900 dark:bg-gray-700"></div>
            <time className="mb-1 text-sm font-normal leading-none text-gray-400 dark:text-gray-500 absolute -left-[120px] top-1 tracking-wider">
              {item.date.getFullYear().toString() +
                "/" +
                item.date.getMonth().toString() +
                "/" +
                item.date.getDate().toString() +
                "\t" +
                item.date.getHours() +
                ":" +
                item.date.getMinutes()}
            </time>
            <h2 className={orderColors[item.title as keyof typeof orderColors]}>
              {item.title.toUpperCase()}
            </h2>
          </li>
        ))}
      </ol>
    </div>
  );
};

export default Timeline;
